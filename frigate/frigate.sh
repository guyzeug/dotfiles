#!/bin/bash

# ==============================================================================
# Script d'installation pour Frigate avec Docker sur Debian 13
# Auteur: Valentin Goudet (Howmation) - Genere avec l'aide de Gemini
# Version: 2.5 (Alerte GPU flexible)
# Description: Automatise l'installation de Frigate, Docker, et des pilotes
#              Intel pour l'acceleration materielle (VA-API).
# ==============================================================================

# --- Variables de couleur pour les messages ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Fonctions pour afficher les messages ---
log_info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}[ATTENTION] $1${NC}"
}

log_success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}"
}

log_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

# --- Verifications preliminaires ---
log_info "Debut des verifications preliminaires..."

# 1. Verifier si le script est execute en tant que root
if [ "$(id -u)" -ne 0 ]; then
  log_error "Ce script doit être execute avec les privileges root."
  log_error "Veuillez le lancer avec 'sudo $0' ou directement en tant que root (via 'su -')."
  exit 1
fi

# 2. Verifier si l'OS est Debian 13 et demander confirmation si ce n'est pas le cas
if ! grep -q 'VERSION_CODENAME=trixie' /etc/os-release; then
    log_warning "Ce script a ete conçu et teste pour Debian 13 (Trixie)."
    log_warning "Votre systeme d'exploitation n'a pas ete reconnu comme tel."
    log_warning "Certaines commandes (notamment pour l'ajout des depots) pourraient echouer."
    read -p "Voulez-vous continuer malgre tout ? (o/N) " -n 1 -r REPLY
    echo
    if [[ ! $REPLY =~ ^[OoYy]$ ]]; then
        log_info "Operation annulee par l'utilisateur."
        exit 0
    fi
    log_info "Continuation de l'installation sur un systeme non-standard a vos risques et perils."
else
    log_success "Systeme d'exploitation Debian 13 (Trixie) detecte."
fi

# --- Demander le nom de l'utilisateur a configurer ---
read -p "Entrez le nom de l'utilisateur non-root a configurer (ex: valentin): " TARGET_USER
if ! id "$TARGET_USER" &>/dev/null; then
    log_error "L'utilisateur '$TARGET_USER' n'existe pas. Veuillez le creer d'abord."
    exit 1
fi
log_info "L'utilisateur '$TARGET_USER' sera ajoute aux groupes 'sudo' et 'docker'."

# ==============================================================================
# SECTION 1: MISE A JOUR DU SYSTeME ET DePENDANCES (INCLUANT SUDO)
# ==============================================================================
log_info "SECTION 1: Mise a jour du systeme et installation des dependances..."

apt-get update
apt-get upgrade -y

log_info "Installation de sudo, curl et des paquets pour les pilotes Intel..."
apt-get install -y sudo curl intel-media-va-driver intel-gpu-tools vainfo ca-certificates ffmpeg

# Configuration des mises a jour automatiques (unattended-upgrades)
log_info "Configuration des mises a jour automatiques..."
apt-get install -y unattended-upgrades
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades

log_info "Ajout de l'utilisateur $TARGET_USER au groupe sudo..."
usermod -aG sudo "$TARGET_USER"

log_success "Systeme mis a jour et dependances installees."

# ==============================================================================
# SECTION 2: VeRIFICATION DE L'ACCeLeRATION MATERIELLE
# ==============================================================================
log_info "SECTION 2: Verification de l'acceleration materielle Intel (VA-API)..."

HAS_INTEL_GPU=true

if [ -e "/dev/dri/renderD128" ]; then
    log_success "Le peripherique /dev/dri/renderD128 a ete trouve. L'acceleration materielle est disponible."
else
    echo
    log_warning "-----------------------------------------------------------------------"
    log_warning "ALERTE : Le peripherique /dev/dri/renderD128 est INTROUVABLE."
    log_warning "-----------------------------------------------------------------------"
    echo -e "${YELLOW}Cela signifie que votre systeme ne detecte pas de GPU Intel compatible.${NC}"
    echo -e "${YELLOW}CONSEQUENCES :${NC}"
    echo -e " 1. Frigate ne pourra pas utiliser l'acceleration materielle (VA-API) pour le decodage."
    echo -e " 2. La detection d'objets (OpenVINO) ne pourra pas utiliser le GPU."
    echo -e " 3. ${RED}Tout le travail se fera sur le CPU.${NC}"
    echo -e "    -> Si vous n'avez pas de Coral TPU, votre CPU risque de saturer a 100%."
    echo
    
    read -p "Voulez-vous quand même continuer l'installation ? (o/N) " -n 1 -r REPLY
    echo
    if [[ ! $REPLY =~ ^[OoYy]$ ]]; then
        log_error "Installation interrompue par l'utilisateur."
        exit 1
    fi
    
    HAS_INTEL_GPU=false
    log_info "Continuation de l'installation SANS support GPU Intel."
fi

# ==============================================================================
# SECTION 3: INSTALLATION DE DOCKER
# ==============================================================================
log_info "SECTION 3: Installation de Docker et Docker Compose..."

# Ajout du depot officiel de Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installation des paquets Docker
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Ajout de l'utilisateur au groupe docker
log_info "Ajout de l'utilisateur $TARGET_USER au groupe docker..."
groupadd -f docker
usermod -aG docker "$TARGET_USER"

# Activation des services Docker
log_info "Activation et demarrage des services Docker..."
systemctl enable docker.service
systemctl enable containerd.service
systemctl start docker.service

log_success "Docker et Docker Compose ont ete installes avec succes."

# ==============================================================================
# SECTION 4: CONFIGURATION DE FRIGATE
# ==============================================================================
log_info "SECTION 4: Creation de la configuration pour Frigate..."

FRIGATE_DIR="/home/$TARGET_USER/frigate"
CONFIG_DIR="$FRIGATE_DIR/config"
STORAGE_DIR="$FRIGATE_DIR/storage"
COMPOSE_FILE="$FRIGATE_DIR/docker-compose.yml"
CONFIG_FILE="$CONFIG_DIR/config.yml"

log_info "Creation de l'arborescence de dossiers dans $FRIGATE_DIR..."
mkdir -p "$CONFIG_DIR"
mkdir -p "$STORAGE_DIR"

# Preparation du bloc devices pour docker-compose
# Note: Les 4 espaces au debut sont cruciaux pour l'indentation YAML
if [ "$HAS_INTEL_GPU" = true ]; then
    DEVICES_BLOCK="    devices:
      - /dev/dri/renderD128:/dev/dri/renderD128"
    OPENVINO_DEVICE="GPU"
else
    DEVICES_BLOCK="#    devices:
#      - /dev/dri/renderD128:/dev/dri/renderD128 # Decommentez si GPU present"
    OPENVINO_DEVICE="CPU"
fi

# --- Creation du fichier docker-compose.yml ---
log_info "Creation du fichier docker-compose.yml..."
cat << EOF > "$COMPOSE_FILE"
services:
  frigate:
    container_name: frigate
    privileged: true
    restart: unless-stopped
    image: ghcr.io/blakeblackshear/frigate:stable
    shm_size: '2g'
$DEVICES_BLOCK
    volumes:
      - ./config:/config
      - ./storage:/media/frigate
      - type: tmpfs
        target: /tmp/cache
        tmpfs:
          size: 4096m
    ports:
      - "5000:5000"
      - "8555:8555"
      - "1935:1935"
EOF

# --- Creation du fichier config.yml ---
log_info "Creation du fichier de configuration config.yml..."
cat << EOF > "$CONFIG_FILE"
mqtt:
  enabled: False
#  host: 192.168.1.123
#  user: mqtt
#  password: mqtt

detectors:
  ov:
    type: openvino
    device: $OPENVINO_DEVICE

model:
  width: 300
  height: 300
  input_tensor: nhwc
  input_pixel_format: bgr
  path: /openvino-model/ssdlite_mobilenet_v2.xml
  labelmap_path: /openvino-model/coco_91cl_bkgr.txt

ffmpeg:
  hwaccel_args: preset-vaapi

detect:
  enabled: true
  width: 1280
  height: 720
  fps: 5

record:
  enabled: true
  retain:
    days: 3
    mode: motion

cameras:
  camera1:
    ffmpeg:
      inputs:
        - path: rtsp://utilisateur:motdepasse@xxx.xxx.x.xx
          roles:
            - detect
            - record
    detect:
      enabled: true
    objects:
      track:
        - person
        - cat
EOF

# --- Attribution des permissions ---
log_info "Attribution des permissions a l'utilisateur $TARGET_USER..."
chown -R "$TARGET_USER":"$TARGET_USER" "$FRIGATE_DIR"

log_success "La configuration de Frigate a ete creee avec succes."

if [ "$HAS_INTEL_GPU" = false ]; then
    echo
    log_warning "RAPPEL IMPORTANT : L'installation a ete forcee SANS GPU Intel."
    log_warning "Le fichier docker-compose.yml a ete genere avec la section 'devices' commentee."
    log_warning "Dans config.yml, OpenVINO a ete configure sur 'CPU'."
    log_warning "Si vous utilisez un CORAL USB, vous devez editer docker-compose.yml pour mapper le peripherique USB."
fi

# ==============================================================================
# FIN DU SCRIPT
# ==============================================================================
echo
log_success "--------------------------------------------------------"
log_success "L'installation est terminee !"
log_success "--------------------------------------------------------"
echo
log_info "Actions requises de votre part :"
log_info "1. Deconnectez-vous et reconnectez-vous avec l'utilisateur '$TARGET_USER' pour que les changements de groupe (sudo, docker) prennent effet."
log_info "2. Une fois reconnecte, naviguez vers le dossier Frigate avec : cd ~/frigate"
log_info "3. Lancez Frigate avec la commande : docker compose up -d"
echo
log_warning "IMPORTANT: N'oubliez pas de modifier le fichier '~/frigate/config/config.yml' pour ajouter vos cameras."
log_warning "Si vous utilisez MQTT, decommentez et configurez la section 'mqtt' dans ce même fichier."
echo