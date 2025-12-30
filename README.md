# Servidor Minecraft com Docker

Projeto para facilitar a criação e gerenciamento de um servidor Minecraft dentro de um container Docker, com scripts para iniciar, reiniciar e fazer backups automáticos do servidor.

---

## Estrutura do Projeto

- `docker-compose.yml` — Configuração do Docker Compose para subir o servidor Minecraft.  
- `start.sh` — Script para iniciar o servidor.  
- `restart.sh` — Script para reiniciar o servidor.  
- `backup.sh` — Script para criar backups automáticos.  
- `backups/` — Diretório onde os backups são armazenados.  
- `logs/` — Logs do servidor.  
- `data/` — Arquivos de dados do servidor Minecraft (mundo, configurações, whitelist, etc).

---

## Requisitos

- Docker e Docker Compose instalados na máquina.  
- Ubuntu 22 (ou outra distro Linux) — opcional, pode rodar direto no host.  
- Radmin VPN — opcional, para conexão VPN entre jogadores.  
- Acesso SSH para gerenciamento remoto — opcional.

---

## Como usar

```bash
# Iniciar o servidor
./start.sh

# Reiniciar o servidor
./restart.sh

# Criar backup manual
./backup.sh

# Como conectar no servidor Minecraft
Use o IP público da máquina onde o servidor está rodando.

Se usar VPN (exemplo: Radmin VPN), use o IP virtual da VPN para conectar.

# Observações
Os arquivos .jar, pastas backups/ e logs/ são ignorados no Git.

Os arquivos whitelist.json e server.properties dentro da pasta data/ são versionados para manter configurações sincronizadas.

# Como contribuir
Contribuições são bem-vindas! Abra issues ou envie pull requests para melhorias.

# Licença
Este projeto está sob a licença MIT.








