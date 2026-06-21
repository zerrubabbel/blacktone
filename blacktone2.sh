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

#git clone https://github.com/zerrubabbel/blacktone2

#bash $HOME/PATH/TO/blacktone3.sh

# REBOOT

