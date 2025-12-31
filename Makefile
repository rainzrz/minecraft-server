.PHONY: help test test-unit test-integration lint validate clean deploy

# Variáveis
COMPOSE_FILE = docker-compose.yml
TEST_COMPOSE_PROJECT = minecraft-test

help: ## Mostra ajuda
	@echo "Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

test: test-unit test-integration ## Executa todos os testes

test-unit: ## Executa testes unitários
	@echo "Executando testes unitários..."
	@chmod +x tests/unit/*.sh
	@bash tests/unit/test_docker_compose.sh
	@bash tests/unit/test_prometheus_config.sh

test-integration: ## Executa testes de integração
	@echo "Executando testes de integração..."
	@chmod +x tests/integration/*.sh
	@bash tests/integration/test_containers.sh

lint: ## Valida sintaxe dos arquivos YAML
	@echo "Validando docker-compose.yml..."
	@docker compose config > /dev/null
	@echo "✓ docker-compose.yml válido"

validate: lint test-unit ## Valida configuração e executa testes unitários

clean: ## Limpa containers de teste
	@echo "Limpando containers de teste..."
	@docker compose -f $(COMPOSE_FILE) -p $(TEST_COMPOSE_PROJECT) down -v 2>/dev/null || true
	@echo "✓ Limpeza concluída"

deploy: validate ## Valida e prepara para deploy
	@echo "✓ Pronto para deploy"

install-deps: ## Instala dependências (scripts executáveis)
	@chmod +x scripts/*.sh tests/**/*.sh manutenção.sh
	@echo "✓ Scripts tornados executáveis"
