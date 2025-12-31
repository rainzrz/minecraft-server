# Servidor Minecraft com Docker

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Minecraft](https://img.shields.io/badge/Minecraft-62B47A?style=for-the-badge&logo=minecraft&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)

> Projeto completo para criar e gerenciar um servidor Minecraft em Docker, com monitoramento avançado usando Prometheus e Grafana.

---

## Índicee

- [Características](#características)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Requisitos](#requisitos)
- [Como Usar](#como-usar)
- [Conexão](#conexão)
- [Monitoramento](#monitoramento)
- [Licença](#licença)

---

## Características

- **Servidor Minecraft Paper** - Performance otimizada
- **Docker Compose** - Deploy simples e rápido
- **Monitoramento Completo** - Prometheus + Grafana
- **Painel de Manutenção** - Script interativo para gerenciar o servidor
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
├── manutenção.sh             # Painel de controle do servidor
└── README.md                 # Este arquivo
```

---

## Requisitos

| Requisito | Descrição |
|-----------|-----------|
| **Docker** | Docker Engine ou Docker Desktop instalado |
| **Docker Compose** | Versão 2.0+ (já incluído no Docker Desktop) |
| **Sistema Operacional** | Linux, Windows ou macOS |
| **Portas Disponíveis** | 25565, 25575, 9090, 3000 |
| **Espaço em Disco** | Mínimo 10GB livres (recomendado 20GB+) |
| **RAM** | Mínimo 4GB (recomendado 8GB+ para servidor) |

> **Nota:** VPN (Radmin VPN) e acesso SSH são opcionais.

---

## Como Usar

### Painel de Manutenção (Recomendado)

O script `manutenção.sh` oferece um painel interativo para gerenciar o servidor:

```bash
./manutenção.sh
```

O painel oferece as seguintes opções:

1. **Iniciar servidor** - Inicia todos os serviços (Minecraft, Prometheus, Grafana)
2. **Parar servidor** - Para todos os serviços
3. **Reiniciar servidor** - Reinicia todos os serviços
4. **Ver logs do servidor** - Exibe os logs do servidor Minecraft
5. **Fazer backup do mundo** - Cria um backup do mundo com timestamp
6. **Sair** - Encerra o painel

### Comandos Docker Compose (Alternativa)

Você também pode usar os comandos Docker Compose diretamente:

```bash
# Iniciar todos os serviços
docker compose up -d

# Parar todos os serviços
docker compose down

# Reiniciar todos os serviços
docker compose restart

# Ver logs de todos os serviços
docker compose logs -f

# Ver logs apenas do servidor Minecraft
docker compose logs -f minecraft-server
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

> **Importante**: Altere a senha do Grafana no primeiro login!

## Licença

Este projeto está sob a licença **MIT**. Veja o arquivo `LICENSE` para mais detalhes.

---

<div align="center">

**Desenvolvido para a comunidade Minecraft**

Se este projeto foi útil, considere dar uma estrela!

</div>
