# blacktone1.sh
# ENVIRONMENT CHECKS

if [[ ! -f /etc/arch-release ]]; then
    echo "This script requires Arch Linux."
    exit 1
fi

if ! command -v systemctl >/dev/null; then
    echo "systemd is required."
    exit 1
fi

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
#THREADS=${THREADS:-$(nproc)} # prepped for Code Red setup script

# dependency list: /etc/pacman.conf etc/pacman.d/mirrorlis

clear

# PREAMBLE

sleep 2

echo "Blacktone aims to quickly assemble a ready and pleasant desktop."
echo " "
echo "This Blacktone script assumes some prerequisite conditions are met:"
echo " "
echo "1. You have a ready and bootable base install of Arch Linux"
echo "2. You are using systemd"
echo "3. You are familiar with the curated software and configurations provided by Blacktone"
echo "    - See README.md for details"
echo " "
echo "If ANY of these conditions are not met, please exit this script"
sleep 3

readyup() {
  local readystate

  echo "Are the prerequisite conditions met, and do you wish to continue?"

  read -rp "to continue, type exactly 'yes' and press enter"  " readystate

  if [[ "$readystate" != "yes" ]]; then
    echo "exiting blacktone1.sh"
    exit 1
  fi
}

readyup

# PACMAN MIRRORS

echo "Optimizin pacman mirrors"

mirrors_bak() {
  sudo cp /etc/pacman.conf /etc/pacman.conf.bak

  curl -fsSL \
  https://raw.githubusercontent.com/zerrubabbel/blacktone/main/pacman.conf \
  | sudo tee /etc/pacman.conf >/dev/null
  
  sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
}

mirrors_bak
sudo pacman -Syu
sudo pacman -S reflector

mirrors() {
  local country

  read -rp "Which country? [United States] " country
  country="${country:-United States}"

  sudo reflector \
    --verbose \
    --sort rate \
    -l 30 \
    -c "$country" \
    -p https \
    --save /etc/pacman.d/mirrorlist
}

mirrors
sudo pacman -Syu --noconfirm
sudo systemctl enable reflector.service

clear

# ROOT SOFTWARE

echo "Installing root and CLI software... "

sudo pacman -S --needed \
  kitty \
  ufw \
  noto-fonts-cjk \
  bluez \
  btop \
  fastfetch \
  nano \
  base-devel \
  git

echo "Enabling services... "
sudo systemctl enable bluetooth.service
sudo ufw enable
sudo ufw status
sleep 5

clear

# GNOME

echo "Installing gnome"

sudo pacman -S gnome
sudo systemctl enable gdm.service

sleep 3
clear

#CLEANUP PREP AND REBOOT

#Place Holder

echo "This is the end of Blacktone part 1. A system reboot is required to complete setup"
sleep 3

intermission() {
  local reboot_choice

  read -rp "Would you like to reboot now? [Y/n] " reboot_choice

  if [[ -z "$reboot_choice" || ! "$reboot_choice" =~ ^[Nn]$ ]]; then
    echo "Rebooting... "
    sleep 3
    sudo reboot -f
  else
    echo "Reboot declined, returning to session... "
    exit 0
  fi
}

intermission
