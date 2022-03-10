#bin/bash 

# Caso exista alguma trava de um processo.
sudo rm /var/lib/dpkg/lock-frontend ; sudo rm /var/cache/apt/archives/lock;

# Instalação do Softwares-Properties-Common e Adição do PPA do PHP
sudo apt install software-properties-common ; sudo add-apt-repository ppa:ondrej/php ;

#Instalação do Docker e Docker-Compose
sudo apt install docker && apt install docker-compose -y

# Atualizaçao geral de repositórios
sudo apt update &&

# Instalacao de pacotes e programas nativos do repositorio principal do Ubuntu
sudo apt install python3 git curl libssl-dev php8.1 composer php8.1-common php8.1-mysql php8.1-xml php8.1-xmlrpc php8.1-curl php8.1-gd php8.1-imagick php8.1-cli php8.1-dev php8.1-imap php8.1-mbstring php8.1-opcache php8.1-soap php8.1-zip php8.1-intl php8.1-xdebug php8.1-pgsql -y &&

#Instalação PostgreSQL e PGAdmin 4
sudo apt install postgresql-12 -y
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add -y
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
sudo apt install pgadmin4

# Instalaçao dos softwares que utilizam o gerenciador de pacotes snap

sudo snap install snapcraft --classic &&
sudo snap install phpstorm --classic &&
sudo snap install postman &&
sudo snap install node --classic &&
sudo snap install code --classic &&
sudo snap install dbeaver-ce &&
sudo snap install intellij-idea-community --classic &&
sudo snap install clion --classic && 
sudo snap install cmake --classic &&
sudo snap install spotify &&
sudo snap install vlc && 
sudo snap install ramboxpro &&

# Softwares que precisam de Download externo

# Caso ainda exista alguma trava de um processo.
sudo rm /var/lib/dpkg/lock-frontend ; sudo rm /var/cache/apt/archives/lock;

cd ~/Downloads/ &&wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo dpkg -i *.deb 

echo "Execução Finalizada! Reiniciando o Sistema para concluir as modificações"

sudo reboot now
