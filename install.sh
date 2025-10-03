#!/bin/bash

# Script de configuração completa do ambiente de desenvolvimento
# Compatível com Debian/Ubuntu
# Autor: TeuBarbeiro Team
# Data: $(date +"%d/%m/%Y")

set -e  # Para em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERRO] $1${NC}"
}

warning() {
    echo -e "${YELLOW}[AVISO] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# Verificar se é root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        error "Este script não deve ser executado como root. Execute como usuário normal."
        exit 1
    fi
}

# Verificar se é Debian/Ubuntu
check_distro() {
    if ! command -v apt &> /dev/null; then
        error "Este script é compatível apenas com distribuições baseadas em Debian/Ubuntu"
        exit 1
    fi
    log "Sistema compatível detectado"
}

# Atualizar sistema
update_system() {
    log "Atualizando sistema..."
    sudo apt update && sudo apt upgrade -y
    log "Sistema atualizado com sucesso"
}

# Instalar dependências básicas
install_basic_dependencies() {
    log "Instalando dependências básicas..."
    sudo apt install -y \
        curl \
        wget \
        gnupg \
        lsb-release \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        git \
        unzip \
        zip \
        build-essential
    log "Dependências básicas instaladas"
}

# Instalar PHP CLI e extensões
install_php() {
    log "Instalando PHP CLI..."

    # Instalar PHP CLI (já vem com extensões comuns e PHP 8.4)
    sudo apt install -y php-cli

    # Instalar algumas extensões específicas que podem ser úteis para desenvolvimento Laravel
    sudo apt install -y \
        php-mysql \
        php-pgsql \
        php-sqlite3 \
        php-redis \
        php-xdebug \
        php-curl \
        php-xml \
        php-mbstring \
        php-zip \
        php-bcmath

    # Verificar instalação do PHP
    php_version=$(php -v | head -n1)
    log "PHP instalado: $php_version"
}

# Instalar Composer
install_composer() {
    log "Instalando Composer..."

    # Navega para o diretório temporário para garantir permissão de escrita
    pushd /tmp > /dev/null

    # Download e verificação do Composer
    EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
        error "Checksum do Composer inválido"
        rm composer-setup.php
        popd > /dev/null # Garante que vamos voltar ao diretório original
        exit 1
    fi

    php composer-setup.php --quiet
    rm composer-setup.php
    sudo mv composer.phar /usr/local/bin/composer
    sudo chmod +x /usr/local/bin/composer

    # Volta para o diretório original
    popd > /dev/null

    composer_version=$(composer --version)
    log "Composer instalado: $composer_version"
}

# Instalar Node.js e NPM
install_nodejs() {
    log "Instalando Node.js e NPM..."

    # Instalar via NodeSource repository (versão LTS)
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs

    # Verificar instalação
    node_version=$(node --version)
    npm_version=$(npm --version)
    log "Node.js instalado: $node_version"
    log "NPM instalado: $npm_version"
}

# Instalar PostgreSQL
install_postgresql() {
    log "Verificando PostgreSQL..."

    if systemctl list-units --type=service | grep -q postgresql; then
        warning "PostgreSQL já está instalado"
        sudo systemctl enable postgresql
        sudo systemctl start postgresql
        log "Serviço PostgreSQL ativado e iniciado"
    else
        log "Instalando PostgreSQL..."
        sudo apt install -y postgresql postgresql-contrib postgresql-client

        # Ativar e iniciar serviço
        sudo systemctl enable postgresql
        sudo systemctl start postgresql

        log "PostgreSQL instalado, ativado e iniciado"
        info "Para configurar senha do usuário postgres: sudo -u postgres psql -c \"ALTER USER postgres PASSWORD 'sua_senha';\""
    fi

    # Verificar status
    if systemctl is-active --quiet postgresql; then
        log "PostgreSQL está rodando"
    else
        error "Falha ao iniciar PostgreSQL"
    fi
}

# Instalar VS Code
install_vscode() {
    log "Instalando Visual Studio Code..."

    # Adicionar chave GPG da Microsoft
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/

    # Adicionar repositório
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

    sudo apt update
    sudo apt install -y code

    log "VS Code instalado com sucesso"
}

# Instalar PhpStorm
install_phpstorm() {
    log "Instalando PhpStorm via Snap..."

    # Instalar snapd se não estiver instalado
    if ! command -v snap &> /dev/null; then
        sudo apt install -y snapd
    fi

    sudo snap install phpstorm --classic
    log "PhpStorm instalado com sucesso"
}

# Instalar Insomnia
install_insomnia() {
    log "Instalando Insomnia..."

    # Adicionar chave e repositório do Insomnia
    curl -1sLf 'https://packages.konghq.com/public/insomnia/gpg.DE2A7741A50DEBCE.key' | sudo gpg --dearmor -o /usr/share/keyrings/insomnia.gpg
    echo "deb [signed-by=/usr/share/keyrings/insomnia.gpg arch=amd64] https://packages.konghq.com/public/insomnia/deb/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/insomnia.list

    sudo apt update
    sudo apt install -y insomnia

    log "Insomnia instalado com sucesso"
}

# Instalar DBeaver
install_dbeaver() {
    log "Instalando DBeaver..."

    # Download da versão mais recente
    wget -O dbeaver.deb "https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"
    sudo dpkg -i dbeaver.deb

    # Corrigir dependências se necessário
    sudo apt install -f -y

    rm dbeaver.deb
    log "DBeaver instalado com sucesso"
}

# Instalar Brave Browser
install_brave() {
    log "Instalando Brave Browser..."

    # Adicionar chave e repositório do Brave
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

    sudo apt update
    sudo apt install -y brave-browser

    log "Brave Browser instalado com sucesso"
}

# Instalar Steam
install_steam() {
    log "Instalando Steam..."

    # Habilitar arquitetura i386 para jogos 32-bit
    sudo dpkg --add-architecture i386
    sudo apt update

    # Instalar Steam
    sudo apt install -y steam

    log "Steam instalado com sucesso"
}

# Limpeza final
cleanup() {
    log "Realizando limpeza final..."
    sudo apt autoremove -y
    sudo apt autoclean
    log "Limpeza concluída"
}

# Mostrar resumo das instalações
show_summary() {
    echo ""
    echo "=========================================="
    log "RESUMO DAS INSTALAÇÕES"
    echo "=========================================="

    echo "PHP: $(php --version | head -n1)"
    echo "Composer: $(composer --version)"
    echo "Node.js: $(node --version)"
    echo "NPM: $(npm --version)"
    echo "PostgreSQL: $(sudo -u postgres psql --version)"
    echo "VS Code: $(code --version | head -n1)"
    echo ""

    info "Aplicações instaladas:"
    echo "  - PhpStorm (via Snap)"
    echo "  - Insomnia"
    echo "  - DBeaver"
    echo "  - Brave Browser"
    echo "  - Steam"
    echo ""

    warning "NOTAS IMPORTANTES:"
    echo "  1. Configure a senha do PostgreSQL: sudo -u postgres psql -c \"ALTER USER postgres PASSWORD 'sua_senha';\""
    echo "  2. PhpStorm requer licença (versão trial disponível)"
    echo "  3. Reinicie o sistema para garantir que todas as configurações sejam aplicadas"
    echo ""

    log "Instalação concluída com sucesso! 🚀"
}

# Função principal
main() {
    echo "=========================================="
    log "SCRIPT DE CONFIGURAÇÃO DO AMBIENTE DE DESENVOLVIMENTO"
    echo "=========================================="

    check_root
    check_distro

    log "Iniciando instalação..."
    sleep 2

    update_system
    install_basic_dependencies
    install_php
    install_composer
    install_nodejs
    install_postgresql
    install_vscode
    install_phpstorm
    install_insomnia
    install_dbeaver
    install_brave
    install_steam
    cleanup

    show_summary
}

# Executar função principal
main "$@"
