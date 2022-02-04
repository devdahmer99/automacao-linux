#bin/bash 

# Caso exista alguma trava de um processo.
sudo rm /var/lib/dpkg/lock-frontend ; sudo rm /var/cache/apt/archives/lock;

# Instalação do Softwares-Properties-Common e Adição do PPA do PHP7.4
sudo apt install software-properties-common ; sudo add-apt-repository ppa:ondrej/php ;

# Atualizaçao geral de repositórios
sudo apt update &&

# Instalacao de pacotes e programas nativos do repositorio principal do Ubuntu
sudo apt install python3 git curl libssl-dev php8.0 composer php8.0-common php8.0-mysql php8.0-xml php8.0-xmlrpc php8.0-curl php8.0-gd php8.0-imagick php8.0-cli php8.0-dev php8.0-imap php8.0-mbstring php8.0-opcache php8.0-soap php8.0-zip php8.0-intl php8.0-xdebug php8.0-pgsql -y &&


# Instalaçao dos softwares que utilizam o gerenciador de pacotes snap

sudo snap install snapcraft --classic &&
sudo snap install phpstorm --classic &&
sudo snap install postman &&
sudo snap install node --classic &&
sudo snap install code --classic &&
sudo snap install beekeeper-studio &&

# Softwares que precisam de Download externo

cd ~/Downloads/ &&wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo dpkg -i *.deb 

echo "Execução Finalizada! Reiniciando o Sistema para concluir as modificações"

sudo reboot now
