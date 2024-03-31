#!/usr/bin/env bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    # Attempt to rerun the script with sudo
    exec sudo bash "$0" "$@"
fi

# test internet connectivity
timeout 3 bash -c "</dev/tcp/archlinux.org/443" &> /dev/null

flake_git_url="https://github.com/leierr/nixdotsV3.git"

# print nixos logo 4 fun
clear ; neofetch -L

# get flake info & choose system to install
gum style --border double --margin "0 1" --padding "1 2" --border-foreground "006" "Please select NixOS system to install from ${flake_git_url}"
flake_systems="$(nix eval --json --impure --expr "( builtins.attrNames (builtins.getFlake \"git+${flake_git_url}\").nixosConfigurations )" | jq -r '.[]')"
system_to_install="$(gum choose --cursor.foreground=002 ${flake_systems[@]})"

# pretty print disks, then pick one
gum style --border double --margin "0 1" --padding "1 2" --border-foreground "006" """Please Select disk

$(lsblk -o NAME,SIZE,MOUNTPOINT,TYPE)"""
installdisk="$(gum choose --cursor.foreground=002 "$(lsblk -dnpo NAME -I 8,259,253,254,179 | grep -Pv "mmcblk\dboot\d")")"

# sanity check
[[ -n "${installdisk}" && -b "${installdisk}" ]]

gum confirm """Proceed with these settings?

System: ${system_to_install}
Disk: ${installdisk}""" --prompt.border "double" \
--prompt.padding "1 2" --selected.background "001" \
--prompt.margin "0 1" --prompt.border-foreground "006"

clear

gum spin --spinner line --show-output --title "Partitioning Disk" -- bash -c '''
umount -AR /mnt
swapoff -a
wipefs -af "${installdisk}"

sfdisk "${installdisk}" <<EOF
label: gpt
;512Mib;U;*
;+;L
EOF

json_disk_info="$(lsblk -pJ ${installdisk})"
boot_disk="$(jq -r --arg disk "${installdisk}" ".blockdevices[] | select (.name == $disk).children[0].name" <<< "${json_disk_info}")"
root_disk="$(jq -r --arg disk "${installdisk}" ".blockdevices[] | select (.name == $disk).children[1].name" <<< "${json_disk_info}")"

# sanity check
for disk in "${json_disk_info}" "${boot_disk}" "${root_disk}"
do
    [[ -n "${disk}" && -b "${disk}" ]]
done

mkfs.fat -I -F 32 "${boot_disk}" -n NIXBOOT
mkfs.ext4 -F "${root_disk}" -L NIXROOT

start_time=$SECONDS
while [[ ! -e "/dev/disk/by-label/NIXROOT" || ! -e "/dev/disk/by-label/NIXBOOT" ]] && [[ $((SECONDS - start_time)) -lt 30 ]]; do
    sleep 2
done

mount /dev/disk/by-label/NIXROOT /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot
'''

gum spin --spinner line --show-output --title "Installing OS to /mnt" -- nixos-install --root /mnt --flake "${flake_git_url}"
