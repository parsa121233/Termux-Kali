Kali CLI installer for Termux

A small script to install a command-line only Kali Linux into Termux using proot-distro.
Requirements

    Termux on Android (up-to-date)
    At least 2–4 GB free storage (more recommended for extra packages)
    Run as a regular Termux user (do NOT run as root)
    Optional: run termux-setup-storage once if you want shared storage inside Kali

Files

    install_kali_cli.sh — installer script (CLI-only, no desktop)
    README.md — this file

Quick start

    Save the script to the same directory as this README.
    Make executable:

Code

chmod +x install_kali_cli.sh

Run:

Code

    ./install_kali_cli.sh

After completion enter Kali with:

Code

proot-distro login kali

or the convenience command added to $HOME/bin:

Code

kali

What the script does

    Updates Termux packages (pkg update && pkg upgrade)
    Installs proot-distro if missing
    Removes any existing proot-distro kali install (reinstall behavior)
    Installs Kali via proot-distro (CLI-only)
    Inside Kali runs apt update/upgrade and installs essential command-line tools only (no GUI)
    Adds $HOME/bin/kali helper and a shell alias for quick login
    Writes logs to $HOME/kali_install_cli.log

Troubleshooting

    proot-distro reports no "kali" entry:
        Ensure proot-distro is up to date:

Code

pkg install -y proot-distro

If still missing, install a Kali rootfs manually:

    Download a kalifs tarball matching your architecture (aarch64/armhf).
    Install with:

Code

        proot-distro install --override-image /path/to/kalifs.tar.xz kali

Architecture mismatch:

    Check architecture:

Code

        uname -m

        Use a matching Kali rootfs.
    Insufficient storage:
        Free up space or use external storage and bind it into the distro.
    Network or apt timeouts in Kali:
        Ensure Termux has network access and retry; the script uses noninteractive apt settings.

Verification steps (before running)

Code

pkg update && pkg upgrade -y
uname -m
pkg install -y proot-distro
proot-distro list

Confirm whether kali appears in the list.
Post-install tips

    Mount Termux storage when entering Kali:

Code

proot-distro login kali --bind $HOME/storage:~/storage

Install additional CLI tools inside Kali:

Code

proot-distro login kali -- bash -lc "apt update && apt install -y <packages>"

Remove Kali:

Code

    proot-distro remove kali

Security & notes

    This creates a user-space (rootless) Kali using proot; it is not full virtualization and has limitations.
    The script intentionally avoids installing GUI packages — it's for terminal-only usage.
