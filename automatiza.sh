#!/bin/bash

# Atualizar o sistema
sudo apt update && sudo apt upgrade -y

# Instalar Git
sudo apt install git -y

# Instalar Postman
sudo snap install postman

# Instalar Rider
sudo snap install rider --classic

# Instalar VS Code
sudo snap install code --classic

# Instalar Node.js
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs

# Adicionar PPA para PHP 8 e Instalar PHP 8
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install php8.4 php8.4-cli php8.4-fpm php8.4-mysql -y

# Instalar Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y

# Instalar Docker
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

# Instalar MySQL Server
sudo apt install mysql-server -y
sudo systemctl start mysql
sudo systemctl enable mysql

# Instalar MySQL Workbench
sudo apt install mysql-workbench -y

# Instalar Spotify
sudo snap install spotify

# Instalar .NET 9
wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt install -y dotnet-sdk-9.0

# Otimização do Desempenho do Linux
# Ajustes e configurações de desempenho
# Exemplos:
# - Limpar pacotes desnecessários
# - Ajustar swappiness
# - Configurar serviços para iniciar com o sistema

# Limpar pacotes desnecessários
sudo apt autoremove -y

# Ajustar swappiness (reduzir uso de swap)
sudo sysctl vm.swappiness=10

# Otimizar serviços para inicialização
sudo systemctl disable some-unnecessary-service
# Adicionar mais otimizações conforme necessário

echo "Instalação e otimização concluídas com sucesso!"