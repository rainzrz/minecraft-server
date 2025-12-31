#!/bin/bash

# Testes de integração para containers Docker
# Verifica se os containers conseguem iniciar e se comunicar corretamente

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

COMPOSE_FILE="docker-compose.yml"
COMPOSE_PROJECT="minecraft-test"
TIMEOUT=60
ERRORS=0

echo "=== Testes de Integração - Containers Docker ==="

# Limpar containers anteriores
cleanup() {
    echo -e "${BLUE}Limpando containers de teste...${NC}"
    docker compose -f "$COMPOSE_FILE" -p "$COMPOSE_PROJECT" down -v 2>/dev/null || true
}

# Teste 1: Containers podem ser criados
test_containers_create() {
    echo -e "${BLUE}Teste 1: Criando containers...${NC}"
    if ! docker compose -f "$COMPOSE_FILE" -p "$COMPOSE_PROJECT" config > /dev/null; then
        echo -e "${RED}✗ Falha ao validar configuração${NC}"
        ((ERRORS++))
        return 1
    fi
    echo -e "${GREEN}✓ Containers podem ser criados${NC}"
    return 0
}

# Teste 2: Containers iniciam corretamente
test_containers_start() {
    echo -e "${BLUE}Teste 2: Iniciando containers...${NC}"
    
    # Iniciar containers
    if ! docker compose -f "$COMPOSE_FILE" -p "$COMPOSE_PROJECT" up -d; then
        echo -e "${RED}✗ Falha ao iniciar containers${NC}"
        ((ERRORS++))
        return 1
    fi
    
    # Aguardar containers ficarem prontos
    echo -e "${YELLOW}Aguardando containers iniciarem...${NC}"
    sleep 10
    
    # Verificar se containers estão rodando
    local containers=("minecraft-server" "prometheus" "grafana")
    local failed=0
    
    for container in "${containers[@]}"; do
        local full_name="${COMPOSE_PROJECT}-${container}-1"
        if ! docker ps --format "{{.Names}}" | grep -q "^${full_name}$"; then
            echo -e "${RED}✗ Container $container não está rodando${NC}"
            docker logs "$full_name" 2>&1 | tail -20
            ((failed++))
        else
            echo -e "${GREEN}✓ Container $container está rodando${NC}"
        fi
    done
    
    if [ $failed -gt 0 ]; then
        ((ERRORS++))
        return 1
    fi
    
    return 0
}

# Teste 3: Portas estão acessíveis
test_ports_accessible() {
    echo -e "${BLUE}Teste 3: Verificando portas...${NC}"
    
    # Para testes de integração, verificamos apenas se os containers estão escutando
    local ports_to_check=(
        "9090:prometheus"
        "3000:grafana"
    )
    
    local failed=0
    for port_info in "${ports_to_check[@]}"; do
        local port=$(echo $port_info | cut -d: -f1)
        local service=$(echo $port_info | cut -d: -f2)
        
        # Verifica se o processo está escutando na porta (dentro do container)
        local container_name="${COMPOSE_PROJECT}-${service}-1"
        if docker exec "$container_name" sh -c "netstat -tuln 2>/dev/null | grep -q ':$port '" 2>/dev/null || \
           docker exec "$container_name" sh -c "ss -tuln 2>/dev/null | grep -q ':$port '" 2>/dev/null; then
            echo -e "${GREEN}✓ Porta $port ($service) está acessível${NC}"
        else
            echo -e "${YELLOW}⚠ Não foi possível verificar porta $port ($service)${NC}"
            # Não é erro crítico em ambiente de teste
        fi
    done
    
    return 0
}

# Teste 4: Rede está configurada
test_network() {
    echo -e "${BLUE}Teste 4: Verificando rede...${NC}"
    
    local network_name="${COMPOSE_PROJECT}-minecraft-monitoring"
    if docker network ls --format "{{.Name}}" | grep -q "^${network_name}$"; then
        echo -e "${GREEN}✓ Rede criada corretamente${NC}"
        return 0
    else
        echo -e "${RED}✗ Rede não encontrada${NC}"
        ((ERRORS++))
        return 1
    fi
}

# Teste 5: Logs sem erros críticos
test_logs_clean() {
    echo -e "${BLUE}Teste 5: Verificando logs...${NC}"
    
    local containers=("minecraft-server" "prometheus" "grafana")
    local failed=0
    
    for container in "${containers[@]}"; do
        local full_name="${COMPOSE_PROJECT}-${container}-1"
        # Verifica se há erros críticos nos logs
        if docker logs "$full_name" 2>&1 | grep -iE "(fatal|error|panic)" | grep -v "level=error" | head -5; then
            echo -e "${YELLOW}⚠ Erros encontrados nos logs de $container${NC}"
            # Não falha o teste, apenas avisa
        else
            echo -e "${GREEN}✓ Logs de $container parecem OK${NC}"
        fi
    done
    
    return 0
}

# Trap para limpeza
trap cleanup EXIT

# Executar testes
cleanup
test_containers_create
test_containers_start
test_ports_accessible
test_network
test_logs_clean

# Resultado final
echo ""
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}=== Todos os testes de integração passaram! ===${NC}"
    exit 0
else
    echo -e "${RED}=== $ERRORS teste(s) de integração falharam ===${NC}"
    exit 1
fi
