#bin/bash 

# Caso exista alguma trava de um processo.
sudo rm /var/lib/dpkg/lock-frontend ; sudo rm /var/cache/apt/archives/lock;

# Instalação do Softwares-Properties-Common e Adição do PPA do PHP7.4
sudo apt install software-properties-common ; sudo add-apt-repository ppa:ondrej/php ;

# Atualizaçao geral de repositórios
sudo apt update &&

# Instalacao de pacotes e programas nativos do repositorio principal do Ubuntu
sudo apt install python3 git curl libssl-dev php7.4 composer php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl php-xdebug php7.4-pgsql -y &&

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
