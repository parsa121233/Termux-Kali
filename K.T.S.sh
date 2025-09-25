#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'

DISTRO="kali"
LOG="$HOME/kali_install_cli.log"
PKG="pkg"

timestamp(){ date +"%Y-%m-%d %H:%M:%S"; }
log(){ printf "%s %s\n" "$(timestamp)" "$*" | tee -a "$LOG"; }
err(){ printf "%s ERROR: %s\n" "$(timestamp)" "$*" | tee -a "$LOG" >&2; }

if [ "$(id -u 2>/dev/null || echo 0)" -eq 0 ]; then
  err "Do not run as root. Run as regular Termux user."
  exit 1
fi

log "Starting CLI-only Kali install"

$PKG update -y && $PKG upgrade -y

if ! command -v proot-distro >/dev/null 2>&1; then
  log "Installing proot-distro"
  $PKG install -y proot-distro
fi

if proot-distro list | grep -q "^${DISTRO}\$"; then
  log "Existing '${DISTRO}' distro detected"
  proot-distro remove "${DISTRO}" || true
  log "Removed previous ${DISTRO} installation"
fi

log "Installing ${DISTRO}..."
proot-distro install "${DISTRO}"

log "Configuring CLI-only packages inside ${DISTRO}"
proot-distro login "${DISTRO}" -- bash -lc "set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y
apt-get install -y --no-install-recommends \
  sudo curl wget gnupg lsb-release ca-certificates coreutils \
  openssh-client iproute2 iputils-ping net-tools procps vim less
apt-get clean
rm -rf /var/lib/apt/lists/*
"

mkdir -p "$HOME/bin"
cat >"$HOME/bin/kali" <<'EOF'
#!/usr/bin/env bash
proot-distro login kali
EOF
chmod +x "$HOME/bin/kali"

SHELL_RC="$HOME/.bashrc"
if [ -n "${ZSH_VERSION--}" ]; then SHELL_RC="$HOME/.zshrc"; fi
if ! grep -q 'alias kali=' "$SHELL_RC" 2>/dev/null; then
  printf "\n# quick Kali login\nalias kali=\"$HOME/bin/kali\"\n" >> "$SHELL_RC"
fi

log "CLI-only Kali install complete"
log "Enter Kali with: proot-distro login kali  OR  kali"
printf "\nDone. To enter Kali run:\n  proot-distro login kali\nor simply:\n  kali\n"
