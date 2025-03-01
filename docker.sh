#!/bin/bash

# Script d'installation automatisée de Docker sur Ubuntu 24.04 LTS
# Ce script doit être exécuté avec les privilèges root

# Vérification des privilèges root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root. Utilisez sudo."
    exit 1
fi

echo "Installation automatisée de Docker sur Ubuntu 24.04 LTS"

# Mise à jour des dépôts
echo "Mise à jour des dépôts..."
apt update

# Installation des dépendances requises
echo "Installation des dépendances..."
apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg

# Ajout de la clé GPG officielle de Docker
echo "Ajout de la clé GPG de Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Ajout du dépôt Docker
echo "Ajout du dépôt Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mise à jour des dépôts après ajout du nouveau dépôt
echo "Mise à jour des dépôts..."
apt update

# Installation de Docker Engine, CLI et Containerd
echo "Installation de Docker..."
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Vérification que Docker est bien installé
echo "Vérification de l'installation de Docker..."
docker --version

# Ajout de l'utilisateur courant au groupe docker pour éviter d'utiliser sudo
echo "Ajout de l'utilisateur au groupe docker..."
usermod -aG docker $SUDO_USER

# Configuration pour démarrer Docker au démarrage du système
echo "Configuration du démarrage automatique de Docker..."
systemctl enable docker

# Vérification que le service Docker est en cours d'exécution
echo "Vérification que le service Docker est actif..."
systemctl status docker

echo "Installation de Docker terminée!"
echo "Veuillez vous déconnecter et vous reconnecter pour que les changements de groupe prennent effet."
echo "Après reconnexion, vous pourrez utiliser Docker sans sudo."

# Installation de Docker Compose (optionnel)
echo "Voulez-vous installer Docker Compose? (o/n)"
read -r response
if [[ "$response" =~ ^([oO])$ ]]; then
    echo "Docker Compose est déjà inclus avec docker-compose-plugin"
    echo "Vous pouvez l'utiliser avec la commande: docker compose"
fi
