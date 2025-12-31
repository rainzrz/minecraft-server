#!/bin/bash

# Script principal para executar todos os testes

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Executando Suite de Testes${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

FAILED=0
PASSED=0

# Função para executar teste
run_test() {
    local test_file=$1
    local test_name=$2
    
    if [ -f "$test_file" ]; then
        echo -e "${BLUE}Executando: $test_name${NC}"
        if bash "$test_file"; then
            echo -e "${GREEN}✓ $test_name passou${NC}"
            ((PASSED++))
            return 0
        else
            echo -e "${RED}✗ $test_name falhou${NC}"
            ((FAILED++))
            return 1
        fi
    else
        echo -e "${RED}✗ Teste não encontrado: $test_file${NC}"
        ((FAILED++))
        return 1
    fi
    echo ""
}

# Tornar scripts executáveis
chmod +x tests/unit/*.sh tests/integration/*.sh 2>/dev/null || true

# Testes Unitários
echo -e "${BLUE}--- Testes Unitários ---${NC}"
run_test "tests/unit/test_docker_compose.sh" "Validação docker-compose.yml"
run_test "tests/unit/test_prometheus_config.sh" "Validação prometheus.yml"
echo ""

# Testes de Integração (opcional, pode ser desabilitado em CI)
if [ "${SKIP_INTEGRATION:-false}" != "true" ]; then
    echo -e "${BLUE}--- Testes de Integração ---${NC}"
    run_test "tests/integration/test_containers.sh" "Testes de containers Docker"
    echo ""
else
    echo -e "${BLUE}Testes de integração pulados (SKIP_INTEGRATION=true)${NC}"
    echo ""
fi

# Resultado final
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Resumo dos Testes${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Passaram: $PASSED${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}Falharam: $FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}Falharam: 0${NC}"
    exit 0
fi
