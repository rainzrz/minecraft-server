#!/bin/bash

# Testes unitários para prometheus.yml
# Verifica se a configuração do Prometheus está válida

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

PROMETHEUS_CONFIG="prometheus/prometheus.yml"
ERRORS=0

echo "=== Testes Unitários - prometheus.yml ==="

# Teste 1: Arquivo existe
test_file_exists() {
    if [ ! -f "$PROMETHEUS_CONFIG" ]; then
        echo -e "${RED}✗ Arquivo $PROMETHEUS_CONFIG não encontrado${NC}"
        ((ERRORS++))
        return 1
    fi
    echo -e "${GREEN}✓ Arquivo $PROMETHEUS_CONFIG existe${NC}"
    return 0
}

# Teste 2: Sintaxe YAML válida (usando python ou promtool se disponível)
test_yaml_syntax() {
    # Verifica estrutura básica YAML
    if ! grep -q "global:" "$PROMETHEUS_CONFIG"; then
        echo -e "${RED}✗ Seção 'global' não encontrada${NC}"
        ((ERRORS++))
        return 1
    fi
    
    if ! grep -q "scrape_configs:" "$PROMETHEUS_CONFIG"; then
        echo -e "${RED}✗ Seção 'scrape_configs' não encontrada${NC}"
        ((ERRORS++))
        return 1
    fi
    
    echo -e "${GREEN}✓ Estrutura básica válida${NC}"
    return 0
}

# Teste 3: Configurações obrigatórias presentes
test_required_config() {
    local required_keys=("scrape_interval" "evaluation_interval")
    
    for key in "${required_keys[@]}"; do
        if ! grep -q "$key" "$PROMETHEUS_CONFIG"; then
            echo -e "${RED}✗ Configuração obrigatória '$key' não encontrada${NC}"
            ((ERRORS++))
            return 1
        fi
    done
    
    echo -e "${GREEN}✓ Configurações obrigatórias presentes${NC}"
    return 0
}

# Teste 4: Job do Prometheus configurado
test_prometheus_job() {
    if ! grep -q "job_name.*prometheus" "$PROMETHEUS_CONFIG"; then
        echo -e "${RED}✗ Job 'prometheus' não encontrado${NC}"
        ((ERRORS++))
        return 1
    fi
    echo -e "${GREEN}✓ Job 'prometheus' configurado${NC}"
    return 0
}

# Executar todos os testes
test_file_exists
test_yaml_syntax
test_required_config
test_prometheus_job

# Resultado final
echo ""
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}=== Todos os testes passaram! ===${NC}"
    exit 0
else
    echo -e "${RED}=== $ERRORS teste(s) falharam ===${NC}"
    exit 1
fi
