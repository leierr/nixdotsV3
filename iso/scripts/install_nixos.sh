#!/usr/bin/env bash

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
    ;512Mib;BC13C2FF-59E6-4262-A352-B275FD6F7172
    ;+;L
    EOF

    local boot_disk="$(lsblk -pJ ${installdisk} | jq -r --argjson disk ${installdisk}'.blockdevices.[] | select(.name == $disk).children[0].name')"
    local root_disk="$(lsblk -pJ ${installdisk} | jq -r --argjson disk ${installdisk}'.blockdevices.[] | select(.name == $disk).children[1].name')"

    mkfs.fat -F 32 "${boot_disk}"
    fatlabel "${boot_disk}" NIXBOOT
    mkfs.ext4 "${root_disk}" -L NIXROOT
    mount /dev/disk/by-label/NIXROOT /mnt
    mkdir -p /mnt/boot
    mount /dev/disk/by-label/NIXBOOT /mnt/boot
}

select_install_disk
partition_disk
