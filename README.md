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

### Configuração do Prometheus

O Prometheus está configurado e pronto para coletar métricas. Para coletar métricas específicas do Minecraft, você precisará adicionar um exporter compatível.

### Adicionar Dashboard no Grafana

1. Acesse o Grafana em http://localhost:3000
2. Faça login com as credenciais padrão
3. Vá em **Configuration** → **Data Sources**
4. Clique em **Add data source** e selecione **Prometheus**
5. Configure:
   - **URL**: `http://prometheus:9090`
   - Clique em **Save & Test**
6. Crie dashboards personalizados ou importe dashboards existentes do Grafana

> Veja instruções detalhadas em [prometheus/GRAFANA_SETUP.md](prometheus/GRAFANA_SETUP.md)

### Coletar Métricas

Com Prometheus e Grafana configurados, você pode coletar diversos tipos de métricas. Aqui estão as principais opções:

#### 1. Métricas do Prometheus (Incluídas)

O próprio Prometheus expõe métricas sobre seu funcionamento:

- **Query Performance** - `prometheus_engine_*`
- **Storage** - `prometheus_tsdb_*`
- **HTTP Requests** - `prometheus_http_*`
- **Target Scrapes** - `prometheus_target_*`

Para visualizar: Acesse http://localhost:9090/metrics

#### 2. Métricas do Docker (cAdvisor)

Adicione o cAdvisor para monitorar containers Docker:

Adicione ao `docker-compose.yml`:

```yaml
cadvisor:
  image: gcr.io/cadvisor/cadvisor:latest
  container_name: cadvisor
  ports:
    - "8080:8080"
  volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:ro
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro
  restart: unless-stopped
  networks:
    - minecraft-monitoring
```

Depois adicione ao `prometheus/prometheus.yml`:

```yaml
scrape_configs:
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
```

**Métricas coletadas:**
- Uso de CPU por container
- Uso de memória por container
- Uso de disco
- Tráfego de rede
- Uptime dos containers

#### 3. Métricas do Sistema (Node Exporter)

Para métricas do sistema operacional (CPU, memória, disco, rede do host):

Adicione ao `docker-compose.yml`:

```yaml
node-exporter:
  image: prom/node-exporter:latest
  container_name: node-exporter
  ports:
    - "9100:9100"
  command:
    - '--path.procfs=/host/proc'
    - '--path.rootfs=/rootfs'
    - '--path.sysfs=/host/sys'
    - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
  volumes:
    - /proc:/host/proc:ro
    - /sys:/host/sys:ro
    - /:/rootfs:ro
  restart: unless-stopped
  networks:
    - minecraft-monitoring
```

Adicione ao `prometheus/prometheus.yml`:

```yaml
scrape_configs:
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
```

**Métricas coletadas:**
- CPU usage (percentual por core)
- Memória total e disponível
- Uso de disco e I/O
- Tráfego de rede
- Temperatura (se disponível)
- System load

#### 4. Métricas do Minecraft Server

Para métricas específicas do Minecraft (jogadores, TPS, chunks), você precisará de um exporter compatível. Algumas opções:

- **Plugins do Minecraft**: Instale plugins como "Prometheus Exporter" no servidor Paper
- **Exporters externos**: Procure por imagens Docker que se conectem via RCON

#### Como Adicionar um Exporter

1. Adicione o serviço ao `docker-compose.yml`
2. Adicione a configuração de scrape ao `prometheus/prometheus.yml`
3. Reinicie os serviços: `docker compose restart`
4. Verifique se as métricas aparecem em: http://localhost:9090/targets
5. No Grafana, crie dashboards usando as métricas disponíveis

#### Dashboards Recomendados

No Grafana, você pode importar dashboards prontos:

- **Node Exporter Full** - ID: `1860` (métricas do sistema)
- **Docker Monitoring** - ID: `893` (métricas de containers)
- **Prometheus Stats** - ID: `2` (métricas do Prometheus)

Para importar: Grafana → Dashboards → Import → Digite o ID

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

## Licença

Este projeto está sob a licença **MIT**. Veja o arquivo `LICENSE` para mais detalhes.

---

<div align="center">

**Desenvolvido para a comunidade Minecraft**

Se este projeto foi útil, considere dar uma estrela!

</div>
