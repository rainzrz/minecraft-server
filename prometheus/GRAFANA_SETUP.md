# Configuração do Grafana para Minecraft

## Passo 1: Adicionar Data Source do Prometheus

1. Acesse o Grafana em http://localhost:3000
2. Faça login (usuário: `admin`, senha: `admin`)
3. Vá em **Configuration > Data Sources**
4. Clique em **Add data source**
5. Selecione **Prometheus**
6. Configure:
   - **URL**: `http://prometheus:9090`
   - Deixe as outras opções como padrão
7. Clique em **Save & Test**

## Passo 2: Importar Dashboard do Minecraft

### Opção 1: Dashboard Oficial do Minecraft Exporter

1. Vá em **Dashboards > Import**
2. Digite o ID do dashboard: `21724` (Minecraft Server Dashboard)
3. Selecione o Data Source do Prometheus configurado
4. Clique em **Import**

### Opção 2: Criar Dashboard Personalizado

1. Vá em **Dashboards > New Dashboard**
2. Adicione um painel
3. Configure a query PromQL, por exemplo:
   - `minecraft_players_online` - Jogadores online
   - `minecraft_tps` - TPS do servidor
   - `minecraft_chunks_loaded` - Chunks carregados

## Métricas Disponíveis

Explore todas as métricas disponíveis em: http://localhost:9225/metrics

Algumas métricas comuns:
- `minecraft_players_online` - Número de jogadores online
- `minecraft_tps` - Ticks por segundo
- `minecraft_chunks_loaded` - Chunks carregados
- `minecraft_memory_*` - Métricas de memória
- `minecraft_world_*` - Métricas do mundo
