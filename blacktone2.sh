# blacktone2.sh
# ENVIRONMENT CHECKS

if [[ $EUID -eq 0 ]]; then
    echo "blacktone2.sh cannot be run as root"
    exit 1
fi

if [[ "${XDG_CURRENT_DESKTOP:-}" != *GNOME* ]]; then
    echo "Blacktone2 must be run from a GNOME session."
    exit 1
fi

if [[ ! -f /etc/arch-release ]]; then
    echo "This script requires Arch Linux."
    exit 1
fi

if ! command -v systemctl >/dev/null; then
    echo "systemd is required."
    exit 1
fi

set -euo pipefail

#SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
#THREADS=${THREADS:-$(nproc)} # prepped for Code Red setup script

clear

# RUN blacktone3.sh

git clone https://github.com/zerrubabbel/blacktone2.git "$HOME/.blacktone2/"

bash "$HOME/.blacktone2/blacktone3.sh"

# REBOOT

echo "This is the end of Blacktone setup."
sleep 2
echo "It is recommended to reboot your system."
sleep 2

end_setup() {
    local reboot_choice
    
    read -rp "Would you like to reboot now? [Y/n] " reboot_choice

    if [[ "$reboot_choice" =~ ^[Nn]$ ]]; then
        exit 0
    else
        sudo reboot
    fi
}

end_setup
