# GitHub Actions Workflows

Este diretório contém os workflows de CI/CD para o projeto.

## Workflows Disponíveis

### 1. CI - Continuous Integration (`ci.yml`)

Executa a cada push ou pull request nas branches `main`, `master` ou `develop`.

**Jobs:**
- **lint-and-validate**: Valida sintaxe YAML e docker-compose
- **unit-tests**: Executa testes unitários
- **integration-tests**: Executa testes de integração com containers Docker
- **security-scan**: Análise de segurança com Trivy
- **summary**: Resumo final dos testes

### 2. CD - Continuous Deployment (`cd.yml`)

Executa a cada push na branch `main` ou `master`, ou quando um tag `v*` é criado.

**Requisitos:**
Configure os seguintes secrets no GitHub:
- `SSH_PRIVATE_KEY`: Chave privada SSH para acesso ao servidor
- `SSH_HOST`: Endereço do servidor
- `SSH_USER`: Usuário SSH
- `SSH_PORT`: Porta SSH (opcional, padrão: 22)
- `DEPLOY_PATH`: Caminho no servidor (opcional, padrão: /home/rainz/minecraft-server)

**O que faz:**
1. Valida a configuração
2. Conecta via SSH ao servidor
3. Faz git pull
4. Atualiza containers Docker
5. Verifica saúde dos containers
6. Restaura backup em caso de falha

### 3. Testes Completos (`test.yml`)

Workflow para executar todos os testes manualmente ou em PRs.

## Configurando Secrets

Para configurar os secrets no GitHub:

1. Vá em: Settings → Secrets and variables → Actions
2. Clique em "New repository secret"
3. Adicione cada secret necessário

## Executando Testes Localmente

```bash
# Todos os testes
make test

# Apenas testes unitários
make test-unit

# Apenas testes de integração
make test-integration

# Validar configuração
make validate
```

Ou use o script direto:

```bash
bash scripts/run_tests.sh
```
