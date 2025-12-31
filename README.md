# Servidor Minecraft com Docker

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Minecraft](https://img.shields.io/badge/Minecraft-62B47A?style=for-the-badge&logo=minecraft&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)

> Projeto completo para criar e gerenciar um servidor Minecraft em Docker, com monitoramento avançado usando Prometheus e Grafana.

---

## Índice

- [Características](#características)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Requisitos](#requisitos)
- [Como Usar](#como-usar)
- [Conexão](#conexão)
- [Monitoramento](#monitoramento)
- [Observações](#observações)
- [Contribuindo](#contribuindo)
- [Licença](#licença)

---

## Características

- **Servidor Minecraft Paper** - Performance otimizada
- **Docker Compose** - Deploy simples e rápido
- **Monitoramento Completo** - Prometheus + Grafana
- **Backups Automáticos** - Scripts prontos para uso
- **RCON Habilitado** - Controle remoto do servidor
- **Persistência de Dados** - Volumes Docker configurados

---

## Estrutura do Projeto

```
minecraft-server/
├── docker-compose.yml       # Configuração dos serviços
├── data/                     # Dados do servidor (mundo, configs)
├── logs/                     # Logs do servidor
├── backups/                  # Backups do mundo
├── prometheus/               # Configurações do Prometheus
│   ├── prometheus.yml       # Config do Prometheus
│   └── GRAFANA_SETUP.md     # Guia de setup do Grafana
├── start.sh                  # Script para iniciar
├── restart.sh                # Script para reiniciar
├── backup.sh                 # Script de backup
└── README.md                 # Este arquivo
```

---

## Requisitos

| Requisito | Descrição |
|-----------|-----------|
| **Docker** | Docker Engine ou Docker Desktop instalado |
| **Docker Compose** | Versão 2.0+ (já incluído no Docker Desktop) |
| **Sistema Operacional** | Linux, Windows ou macOS |
| **Portas Disponíveis** | 25565, 25575, 9090, 3000, 9225 |
| **Espaço em Disco** | Mínimo 10GB livres (recomendado 20GB+) |
| **RAM** | Mínimo 4GB (recomendado 8GB+ para servidor) |

> **Nota:** VPN (Radmin VPN) e acesso SSH são opcionais.

---

## Como Usar

### Iniciar o Servidor

```bash
./start.sh
```

ou usando Docker Compose diretamente:

```bash
docker compose up -d
```

### Reiniciar o Servidor

```bash
./restart.sh
```

ou:

```bash
docker compose restart
```

### Criar Backup Manual

```bash
./backup.sh
```

### Ver Logs

```bash
# Logs de todos os serviços
docker compose logs -f

# Logs apenas do servidor Minecraft
docker compose logs -f minecraft-server
```

### Parar o Servidor

```bash
docker compose down
```

---

## Conexão

### Conexão no Minecraft

- **IP Público**: Use o IP público da máquina onde o servidor está rodando
- **Porta**: `25565` (padrão)
- **VPN**: Se usar VPN (ex: Radmin VPN), use o IP virtual da VPN

### Acesso RCON

- **Host**: IP do servidor
- **Porta**: `25575`
- **Senha**: Configurada no `docker-compose.yml`

---

## Monitoramento

O projeto inclui um stack completo de monitoramento com **Prometheus** e **Grafana** para visualizar métricas em tempo real do servidor Minecraft.

### Acessar Interfaces

| Serviço | URL | Credenciais |
|---------|-----|-------------|
| **Grafana** | http://localhost:3000 | `admin` / `admin` |
| **Prometheus** | http://localhost:9090 | - |
| **Minecraft Exporter** | http://localhost:9225/metrics | - |

> **Importante**: Altere a senha do Grafana no primeiro login!

### Configuração do Prometheus

O Prometheus está configurado para coletar métricas do servidor Minecraft através do **Minecraft Exporter**, que se conecta via RCON.

### Adicionar Dashboard no Grafana

1. Acesse o Grafana em http://localhost:3000
2. Faça login com as credenciais padrão
3. Vá em **Configuration** → **Data Sources**
4. Clique em **Add data source** e selecione **Prometheus**
5. Configure:
   - **URL**: `http://prometheus:9090`
   - Clique em **Save & Test**
6. Importe um dashboard do Minecraft:
   - Vá em **Dashboards** → **Import**
   - Digite o ID: `21724` (Minecraft Server Dashboard)
   - Selecione o Data Source do Prometheus
   - Clique em **Import**

> Veja instruções detalhadas em [prometheus/GRAFANA_SETUP.md](prometheus/GRAFANA_SETUP.md)

### Métricas Coletadas

O exporter coleta diversas métricas importantes:

- **Jogadores Online** - Número de jogadores conectados
- **TPS (Ticks Per Second)** - Performance do servidor
- **Uso de Memória** - RAM utilizada pelo servidor
- **Chunks Carregados** - Quantidade de chunks na memória
- **Status do Servidor** - Estado e informações gerais
- **Estatísticas do Mundo** - Informações do mundo atual

---

## Observações

### Arquivos Ignorados

Os seguintes arquivos são **ignorados** no Git:
- `*.jar` - Arquivos JAR do servidor
- `/backups/` - Diretório de backups
- `/logs/` - Logs do servidor
- `/data/*` - Dados do servidor (exceto configurações)

### Arquivos Versionados

Estes arquivos são **versionados** para manter configurações sincronizadas:
- `data/whitelist.json` - Lista de permissões
- `data/server.properties` - Propriedades do servidor

### Segurança

- **RCON Password**: Altere a senha RCON no `docker-compose.yml` antes de usar em produção
- **Grafana Password**: Altere a senha padrão do Grafana no primeiro acesso
- **Firewall**: Configure o firewall adequadamente para expor apenas as portas necessárias

---

## Contribuindo

Contribuições são muito bem-vindas!

1. Faça um Fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

---

## Licença

Este projeto está sob a licença **MIT**. Veja o arquivo `LICENSE` para mais detalhes.

---

<div align="center">

**Desenvolvido para a comunidade Minecraft**

Se este projeto foi útil, considere dar uma estrela!

</div>
