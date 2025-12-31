#!/bin/bash

# Testes unitários para docker-compose.yml
# Verifica se o arquivo está válido e se todos os serviços necessários estão presentes

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

COMPOSE_FILE="docker-compose.yml"
ERRORS=0

echo "=== Testes Unitários - docker-compose.yml ==="

# Teste 1: Arquivo existe
test_file_exists() {
    if [ ! -f "$COMPOSE_FILE" ]; then
        echo -e "${RED}✗ Arquivo $COMPOSE_FILE não encontrado${NC}"
        ((ERRORS++))
        return 1
    fi
    echo -e "${GREEN}✓ Arquivo $COMPOSE_FILE existe${NC}"
    return 0
}

# Teste 2: Validação YAML básica
test_yaml_syntax() {
    if ! docker compose -f "$COMPOSE_FILE" config > /dev/null 2>&1; then
        echo -e "${RED}✗ Erro de sintaxe no $COMPOSE_FILE${NC}"
        docker compose -f "$COMPOSE_FILE" config 2>&1 | head -20
        ((ERRORS++))
        return 1
    fi
    echo -e "${GREEN}✓ Sintaxe YAML válida${NC}"
    return 0
}

# Teste 3: Serviços obrigatórios presentes
test_required_services() {
    local required_services=("minecraft-server" "prometheus" "grafana")
    local missing_services=()
    
    for service in "${required_services[@]}"; do
        if ! docker compose -f "$COMPOSE_FILE" config 2>/dev/null | grep -q "service.*$service"; then
            missing_services+=("$service")
        fi
    done
    
    if [ ${#missing_services[@]} -gt 0 ]; then
        echo -e "${RED}✗ Serviços faltando: ${missing_services[*]}${NC}"
        ((ERRORS++))
        return 1
    fi
    echo -e "${GREEN}✓ Todos os serviços obrigatórios presentes${NC}"
    return 0
}

# Teste 4: Variáveis de ambiente obrigatórias
test_required_env_vars() {
    local required_vars=("EULA" "TYPE" "ENABLE_RCON")
    local missing_vars=()
    
    for var in "${required_vars[@]}"; do
        if ! grep -q "$var" "$COMPOSE_FILE"; then
            missing_vars+=("$var")
        fi
    done
    
    if [ ${#missing_vars[@]} -gt 0 ]; then
        echo -e "${YELLOW}⚠ Variáveis de ambiente não encontradas: ${missing_vars[*]}${NC}"
        # Não é erro crítico, apenas aviso
    else
        echo -e "${GREEN}✓ Variáveis de ambiente obrigatórias presentes${NC}"
    fi
    return 0
}

# Teste 5: Redes configuradas
test_networks() {
    if ! docker compose -f "$COMPOSE_FILE" config 2>/dev/null | grep -q "minecraft-monitoring"; then
        echo -e "${RED}✗ Rede 'minecraft-monitoring' não encontrada${NC}"
        ((ERRORS++))
        return 1
    fi
    echo -e "${GREEN}✓ Rede 'minecraft-monitoring' configurada${NC}"
    return 0
}

# Teste 6: Volumes configurados
test_volumes() {
    if ! docker compose -f "$COMPOSE_FILE" config 2>/dev/null | grep -q "prometheus-data\|grafana-data"; then
        echo -e "${YELLOW}⚠ Volumes não encontrados${NC}"
    else
        echo -e "${GREEN}✓ Volumes configurados${NC}"
    fi
    return 0
}

# Teste 7: Portas não duplicadas
test_port_conflicts() {
    local ports=$(docker compose -f "$COMPOSE_FILE" config 2>/dev/null | grep -oP '"\d+:\d+"' | sort | uniq -d)
    if [ -n "$ports" ]; then
        echo -e "${RED}✗ Portas duplicadas encontradas: $ports${NC}"
        ((ERRORS++))
        return 1
    fi
    echo -e "${GREEN}✓ Nenhum conflito de portas${NC}"
    return 0
}

# Executar todos os testes
test_file_exists
test_yaml_syntax
test_required_services
test_required_env_vars
test_networks
test_volumes
test_port_conflicts

# Resultado final
echo ""
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}=== Todos os testes passaram! ===${NC}"
    exit 0
else
    echo -e "${RED}=== $ERRORS teste(s) falharam ===${NC}"
    exit 1
fi
