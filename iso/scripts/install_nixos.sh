#!/usr/bin/env bash

if [[ $(id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

installdisk=""

function select_install_disk() {
	local disk_list=($(lsblk -dnpo NAME -I 8,259,253,254,179 | grep -Pv "mmcblk\dboot\d"))

	# pretty print disks
	lsblk -o NAME,SIZE,MOUNTPOINT,TYPE
    echo # create some space

	local PS3="Select disk: "
	select disk in ${disk_list[@]} ; do
		[[ -n "$disk" && -e "$disk" && -b "$disk" ]] && break
	done

    installdisk="${disk}"

    if [[ -n "$installdisk" && -b "$installdisk" ]]
    then
        return 0
    else
        echo "Installdisk: $installdisk is either empty or not a block device."
        exit 1
    fi
}

function partition_disk() {
    umount -AR /mnt
    swapoff -a
    wipefs -af "${installdisk}"

    sfdisk "${installdisk}" <<EOF
label: gpt
;512Mib;U;*
;+;L
EOF

    local json_disk_info="$(lsblk -pJ ${installdisk})"
    local boot_disk="$(jq -r --arg disk "${installdisk}" '.blockdevices[] | select (.name == $disk).children[0].name' <<< "${json_disk_info}")"
    local root_disk="$(jq -r --arg disk "${installdisk}" '.blockdevices[] | select (.name == $disk).children[1].name' <<< "${json_disk_info}")"

    mkfs.fat -I -F 32 "${boot_disk}" -n NIXBOOT
    mkfs.ext4 -F "${root_disk}" -L NIXROOT

    while [[ ! -e "/dev/disk/by-label/NIXROOT" || ! -e "/dev/disk/by-label/NIXBOOT" ]]; do
        echo "Waiting for NIXROOT and NIXBOOT to appear..."
        sleep 2
    done

    mount /dev/disk/by-label/NIXROOT /mnt
    mkdir -p /mnt/boot
    mount /dev/disk/by-label/NIXBOOT /mnt/boot

    echo '''
last remaining steps of installation:
-> sudo nixos-install --root /mnt --flake ./nixdots#system

    '''
}

clear
select_install_disk
git clone https://github.com/leierr/nixdotsV3 ./nixdots
partition_disk
