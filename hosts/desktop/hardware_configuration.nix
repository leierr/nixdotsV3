{ pkgs, ... }:
{
  imports = [
    ./monitors.nix
  ];

  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };

    swapDevices = [ ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "btusb" "usb_storage" "sd_mod" ]; # basicly kernel modules needed to mount/boot
    boot.kernelModules = [ "amdgpu" "kvm-amd" ]; # AMD GPU + kvm stuff

    services.xserver.videoDrivers = [ "amdgpu" ];

    powerManagement.cpuFreqGovernor = "performance";

    hardware.cpu.amd.updateMicrocode = true; # AMD CPU
    hardware.enableRedistributableFirmware = true;
    hardware.opengl = {
      enable = true; # Mesa
      driSupport = true; # Vulkan
      driSupport32Bit = true; # Vulkan 32 bit support
      extraPackages = with pkgs; [
        rocmPackages.clr.icd # AMD OpenCL
        amdvlk # AMDGPU vulkan
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk # AMDGPU vulkan 32 bit support
      ];
    };

    systemd.tmpfiles.rules = [ "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}" ];
  };
}
