set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    # Attempt to rerun the script with sudo
    exec sudo bash "$0" "$@"
fi

# test internet connectivity
timeout 3 bash -c "</dev/tcp/archlinux.org/443" &> /dev/null

flake_git_url="https://github.com/leierr/nixdotsV3.git"

# print nixos logo 4 fun
clear ; fastfetch -s ":"

# get flake info & choose system to install
gum style --border double --margin "0 1" --padding "1 2" --border-foreground "006" "Please select NixOS system to install from ${flake_git_url}"
flake_systems="$(nix flake show --no-write-lock-file --json "git+${flake_git_url}" 2>/dev/null | jq -r '.nixosConfigurations | keys[]')"
system_to_install="$(gum choose --cursor.foreground=002 ${flake_systems[@]})"

# pretty print disks, then pick one
clear ; gum style --border double --margin "0 1" --padding "1 2" --border-foreground "006" """Please Select disk

$(lsblk -o NAME,SIZE,MOUNTPOINT,TYPE)"""
installdisk="$(gum choose --cursor.foreground=002 $(lsblk -dnpo NAME -I 8,259,253,254,179 | grep -Pv "mmcblk\dboot\d"))"

# sanity check
[[ -n "${installdisk}" && -b "${installdisk}" ]]

clear ; gum confirm """Proceed with these settings?

System: ${system_to_install}
Disk: ${installdisk}""" --selected.background "001" --prompt.foreground="006"

clear

echo "Partitioning disk..."

# Use a subshell to temporarily disable exit on error
(
    set +e
    umount -AR /mnt &>/dev/null
    swapoff -a &>/dev/null
    wipefs -af "${installdisk}" &>/dev/null
)

sfdisk "${installdisk}" &>/dev/null <<EOF
label: gpt
;512Mib;U;*
;+;L
EOF

json_disk_info="$(lsblk -pJ ${installdisk})"
boot_disk="$(jq -r --arg disk "${installdisk}" '.blockdevices[] | select (.name == $disk).children[0].name' <<< "${json_disk_info}")"
root_disk="$(jq -r --arg disk "${installdisk}" '.blockdevices[] | select (.name == $disk).children[1].name' <<< "${json_disk_info}")"

# sanity check
for disk in "${boot_disk}" "${root_disk}"
do
    [[ -n "${disk}" && -b "${disk}" ]]
done

mkfs.fat -I -F 32 "${boot_disk}" -n NIXBOOT &>/dev/null
mkfs.ext4 -F "${root_disk}" -L NIXROOT &>/dev/null

start_time=$SECONDS
while [[ ! -e "/dev/disk/by-label/NIXROOT" || ! -e "/dev/disk/by-label/NIXBOOT" ]] && [[ $((SECONDS - start_time)) -lt 30 ]]; do
    sleep 2
done

mount /dev/disk/by-label/NIXROOT /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot

git clone ${flake_git_url} /mnt/etc/nixos/ &>/dev/null
nixos-install --cores 0 --no-root-passwd --option eval-cache false --root /mnt --flake "/mnt/etc/nixos#${system_to_install}"
