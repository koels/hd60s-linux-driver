#!/bin/sh
# Installs the HD60 S driver via DKMS and loads it at boot. Run with sudo.
set -e
cd "$(dirname "$0")"
VER=0.1
pacman -S --needed --noconfirm dkms
if lsmod | grep -q "^hd60s " && ! rmmod hd60s; then echo "hd60s is in use (OBS or PipeWire); reboot to load the new build"; fi
dkms remove hd60s/$VER --all 2>/dev/null || true
rm -rf /usr/src/hd60s-$VER
mkdir -p /usr/src/hd60s-$VER
cp -r Makefile dkms.conf *.c *.h LICENSE.txt /usr/src/hd60s-$VER/
dkms install hd60s/$VER
echo hd60s > /etc/modules-load.d/hd60s.conf
modprobe hd60s
dkms status hd60s
modinfo hd60s | grep -E '^(filename|signer|sig_key)' || true
