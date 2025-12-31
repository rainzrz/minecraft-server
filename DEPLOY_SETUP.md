# Configuração de Deploy - GitHub Secrets

Este guia explica como configurar os secrets necessários para o deploy automático via GitHub Actions.

## Onde Configurar

**Use: Repository secrets** (não Environment secrets)

### Como Acessar

1. Vá para o seu repositório no GitHub
2. Clique em **Settings** (Configurações)
3. No menu lateral, vá em **Secrets and variables** → **Actions**
4. Clique na aba **Secrets** (não "Environment secrets")
5. Clique em **New repository secret**

## Secrets Necessários

Configure os seguintes secrets:

### Obrigatórios

#### SSH_PRIVATE_KEY
A chave privada SSH para acessar o servidor.

**Como gerar (se necessário):**
```bash
# No servidor (ou localmente)
ssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/github_deploy

# Copiar a chave PRIVADA (conteúdo do arquivo ~/.ssh/github_deploy)
cat ~/.ssh/github_deploy

# Adicionar a chave PÚBLICA ao servidor
cat ~/.ssh/github_deploy.pub >> ~/.ssh/authorized_keys
```

**Como configurar:**
- Name: `SSH_PRIVATE_KEY`
- Secret: Cole todo o conteúdo da chave privada (incluindo `-----BEGIN ...` e `-----END ...`)

#### SSH_HOST
O endereço IP ou hostname do servidor.

**Exemplo:**
- `192.168.1.100`
- `servidor.example.com`
- `minecraft.meuservidor.com`

#### SSH_USER
O usuário SSH para login no servidor.

**Exemplos:**
- `root`
- `rainz`
- `minecraft`

### Opcionais

#### SSH_PORT
A porta SSH do servidor. Padrão: `22`

**Configurar apenas se usar porta diferente:**
- `2222`
- `2200`

#### DEPLOY_PATH
Caminho no servidor onde o projeto está localizado. Padrão: `/home/rainz/minecraft-server`

**Exemplos:**
- `/home/rainz/minecraft-server`
- `/opt/minecraft-server`
- `/var/www/minecraft-server`

## Verificação

Após configurar os secrets:

1. Faça um push para a branch `main` ou `master`
2. Vá em **Actions** no GitHub
3. Verifique se o workflow `CD - Continuous Deployment` está executando
4. Clique no workflow para ver os logs em tempo real

## Troubleshooting

### Erro: "Permission denied (publickey)"

- Verifique se `SSH_PRIVATE_KEY` está correto (inclui linhas de início/fim)
- Confirme que a chave pública está em `~/.ssh/authorized_keys` no servidor
- Teste a conexão manualmente: `ssh -i ~/.ssh/github_deploy user@host`

### Erro: "Host key verification failed"

O GitHub Actions pode precisar aceitar o host. Você pode adicionar ao workflow:

```yaml
- name: Configurar SSH conhecido hosts
  run: |
    mkdir -p ~/.ssh
    ssh-keyscan -p ${SSH_PORT:-22} ${SSH_HOST} >> ~/.ssh/known_hosts
```

### Erro: "No such file or directory"

- Verifique se `DEPLOY_PATH` está correto
- Confirme que o diretório existe no servidor
- Verifique permissões do diretório

### Testar Conexão Manualmente

Antes de fazer deploy, teste a conexão:

```bash
# Com a chave privada
ssh -i ~/.ssh/github_deploy -p 22 user@host

# Verificar se git funciona no servidor
ssh -i ~/.ssh/github_deploy -p 22 user@host "cd /caminho/do/projeto && git status"
```

## Segurança

⚠️ **Importante:**
- Nunca commite chaves SSH no repositório
- Use secrets do GitHub para dados sensíveis
- Rotacione chaves periodicamente
- Use chaves SSH específicas para GitHub Actions (não reutilize chaves pessoais)
- Considere usar um usuário dedicado no servidor com permissões limitadas
