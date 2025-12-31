# Sistema de CI/CD

Este projeto possui um sistema completo de CI/CD usando GitHub Actions, com testes automatizados e deploy contínuo.

## Estrutura

```
.
├── .github/
│   └── workflows/
│       ├── ci.yml          # Continuous Integration
│       ├── cd.yml          # Continuous Deployment
│       └── test.yml        # Suite completa de testes
├── tests/
│   ├── unit/               # Testes unitários
│   │   ├── test_docker_compose.sh
│   │   └── test_prometheus_config.sh
│   └── integration/        # Testes de integração
│       └── test_containers.sh
├── scripts/
│   └── run_tests.sh        # Script principal de testes
├── Makefile                # Comandos Make para facilitar uso
└── .yamllint.yml           # Configuração do linter YAML
```

## Testes

### Testes Unitários

Testam a validade das configurações sem executar containers:

- **test_docker_compose.sh**: Valida sintaxe, serviços obrigatórios, redes, volumes
- **test_prometheus_config.sh**: Valida configuração do Prometheus

### Testes de Integração

Testam a execução real dos containers:

- **test_containers.sh**: Verifica se containers iniciam, portas, rede, logs

## Executando Testes Localmente

### Usando Make (recomendado)

```bash
# Executar todos os testes
make test

# Apenas testes unitários
make test-unit

# Apenas testes de integração
make test-integration

# Validar configuração (sem testes)
make validate

# Limpar containers de teste
make clean
```

### Usando Scripts Diretamente

```bash
# Todos os testes
bash scripts/run_tests.sh

# Testes unitários individuais
bash tests/unit/test_docker_compose.sh
bash tests/unit/test_prometheus_config.sh

# Testes de integração
bash tests/integration/test_containers.sh
```

### Pular Testes de Integração

Os testes de integração podem demorar mais. Para pular:

```bash
SKIP_INTEGRATION=true bash scripts/run_tests.sh
```

## CI/CD no GitHub Actions

### Continuous Integration (CI)

O workflow `ci.yml` executa automaticamente a cada push ou pull request:

1. **Lint e Validação**: Verifica sintaxe YAML e docker-compose
2. **Testes Unitários**: Valida configurações
3. **Testes de Integração**: Testa containers reais
4. **Análise de Segurança**: Scan com Trivy
5. **Resumo**: Relatório final

### Continuous Deployment (CD)

O workflow `cd.yml` faz deploy automático para o servidor quando:

- Push na branch `main` ou `master`
- Criação de tag `v*`
- Execução manual via `workflow_dispatch`

**Configuração Necessária:**

Configure os seguintes secrets no GitHub (Settings → Secrets → Actions):

- `SSH_PRIVATE_KEY`: Chave privada SSH para o servidor
- `SSH_HOST`: IP ou hostname do servidor
- `SSH_USER`: Usuário SSH (ex: `root` ou `rainz`)
- `SSH_PORT`: Porta SSH (opcional, padrão: 22)
- `DEPLOY_PATH`: Caminho no servidor (opcional, padrão: `/home/rainz/minecraft-server`)

**Processo de Deploy:**

1. Valida configuração localmente
2. Conecta via SSH ao servidor
3. Faz backup do `docker-compose.yml` atual
4. Executa `git pull`
5. Valida nova configuração
6. Atualiza containers com `docker compose pull` e `docker compose up -d`
7. Verifica saúde dos containers
8. Restaura backup se houver falha

## Fluxo de Trabalho Recomendado

1. **Desenvolvimento**: Faça suas alterações na branch `develop` ou feature branch
2. **Testes Locais**: Execute `make test` antes de commitar
3. **Push**: Faça push e o CI executará automaticamente
4. **Review**: Em PRs, verifique o resultado do CI
5. **Merge**: Ao fazer merge em `main`, o CD fará deploy automático
6. **Verificação**: Confirme que o deploy funcionou corretamente

## Troubleshooting

### Testes falhando localmente

- Certifique-se de ter Docker e Docker Compose instalados
- Verifique se as portas necessárias estão livres
- Execute `make clean` para limpar containers de teste antigos

### Deploy falhando

- Verifique os logs do workflow no GitHub Actions
- Confirme que os secrets estão configurados corretamente
- Teste a conexão SSH manualmente
- Verifique se o caminho do deploy está correto
- O sistema tenta restaurar backup automaticamente em caso de falha

### Containers não iniciam nos testes

- Verifique logs: `docker compose -p minecraft-test logs`
- Confirme que todas as imagens estão disponíveis
- Verifique recursos do sistema (memória, CPU)

## Customização

### Adicionar Novos Testes

1. Crie script em `tests/unit/` ou `tests/integration/`
2. Use cores e formato padrão (veja exemplos existentes)
3. Retorne exit code 0 para sucesso, 1 para falha
4. Adicione ao `scripts/run_tests.sh` se necessário

### Modificar Workflows

Edite os arquivos em `.github/workflows/` conforme necessário. Os workflows usam sintaxe padrão do GitHub Actions.

## Melhorias Futuras

- [ ] Testes de performance
- [ ] Notificações Slack/Discord no deploy
- [ ] Rollback automático em caso de falha
- [ ] Health checks mais robustos
- [ ] Testes de carga
- [ ] Cobertura de código
