{
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
  };

  swapDevices = [ ];

  hardware.enableRedistributableFirmware = true;
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.amd.updateMicrocode = true; # AMD CPU

  boot.initrd.kernelModules = [ "amdgpu" "kvm-amd" ]; # AMD GPU
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];

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
}
