#!/bin/bash

# Script d'installation automatisée de VirtualBox sur Ubuntu 24.04 LTS
# Ce script doit être exécuté avec les privilèges root

# Vérification des privilèges root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root. Utilisez sudo."
    exit 1
fi

echo "Installation automatisée de VirtualBox sur Ubuntu 24.04 LTS"

# Mise à jour des dépôts
echo "Mise à jour des dépôts..."
apt update

# Installation des dépendances requises
echo "Installation des dépendances..."
apt install -y wget apt-transport-https gnupg2 software-properties-common

# Ajout de la clé GPG de VirtualBox
echo "Ajout de la clé GPG de VirtualBox..."
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -

# Ajout du dépôt VirtualBox
echo "Ajout du dépôt VirtualBox..."
add-apt-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"

# Mise à jour des dépôts après ajout du nouveau dépôt
echo "Mise à jour des dépôts..."
apt update

# Installation de VirtualBox
echo "Installation de VirtualBox..."
apt install -y virtualbox-7.0

# Installation du pack d'extension (optionnel)
echo "Voulez-vous installer le Pack d'Extension VirtualBox? (o/n)"
read -r response
if [[ "$response" =~ ^([oO])$ ]]; then
    echo "Installation du Pack d'Extension VirtualBox..."
    # Récupération du numéro de version actuel
    VBOX_VERSION=$(vboxmanage -v | cut -d 'r' -f 1)
    # Téléchargement et installation du pack d'extension
    wget -q "https://download.virtualbox.org/virtualbox/${VBOX_VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack"
    VBoxManage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack
    # Nettoyage
    rm Oracle_VM_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack
fi

# Ajout de l'utilisateur courant au groupe vboxusers
echo "Ajout de l'utilisateur au groupe vboxusers..."
usermod -a -G vboxusers $SUDO_USER

echo "Installation de VirtualBox terminée!"
echo "Veuillez vous déconnecter et vous reconnecter pour que les changements de groupe prennent effet."
