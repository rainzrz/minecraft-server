#!/bin/bash

# Nome do container
CONTAINER_NAME="frosthold"

# Cores
RED="\033[38;5;161m"
GREEN="\033[38;5;36m"
YELLOW="\033[38;5;15m"
BLUE="\033[38;5;15m"
CYAN="\033[38;5;15m"
NC="\033[38;5;15m" # Sem cor

while true; do
    clear
    echo -e "${CYAN}======================================${NC}"
    echo -e "${CYAN}     Painel de Controle Frosthold     ${NC}"
    echo -e "${CYAN}======================================${NC}"
    echo -e "${GREEN}1) Iniciar servidor${NC}"
    echo -e "${RED}2) Parar servidor${NC}"
    echo -e "${YELLOW}3) Reiniciar servidor${NC}"
    echo -e "${BLUE}4) Ver logs do servidor${NC}"
    echo -e "${CYAN}5) Fazer backup do mundo${NC}"
    echo -e "${NC}6) Sair"
    echo -e "${CYAN}======================================${NC}"
    read -p "Escolha uma opção: " opc

    case $opc in
        1)
            echo -e "${GREEN}Iniciando o servidor...${NC}"
            docker compose up -d
            read -p "Pressione Enter para continuar..."
            ;;
        2)
            echo -e "${RED}Parando o servidor...${NC}"
            docker compose down
            read -p "Pressione Enter para continuar..."
            ;;
        3)
            echo -e "${YELLOW}Reiniciando o servidor...${NC}"
            docker compose restart
            read -p "Pressione Enter para continuar..."
            ;;
        4)
            echo -e "${BLUE}Mostrando os últimos 50 logs...${NC}"
            docker logs -f --tail 50 $CONTAINER_NAME
            read -p "Pressione Enter para continuar..."
            ;;
        5)
            echo -e "${CYAN}Fazendo backup do mundo...${NC}"
            TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
            BACKUP_DIR="./backups"
            mkdir -p $BACKUP_DIR
            cp -r ./data/world $BACKUP_DIR/world_$TIMESTAMP
            echo -e "${GREEN}Backup criado em $BACKUP_DIR/world_$TIMESTAMP${NC}"
            read -p "Pressione Enter para continuar..."
            ;;
        6)
            echo -e "${CYAN}Saindo...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opção inválida!${NC}"
            read -p "Pressione Enter para continuar..."
            ;;
    esac
done
