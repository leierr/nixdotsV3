{ pkgs, ... }:
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

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ]; # basicly kernel modules needed to mount/boot
  boot.kernelModules = [ "amdgpu" "kvm-amd" ]; # AMD GPU + kvm stuff

  services.xserver.videoDrivers = [ "amdgpu" ];

  powerManagement.cpuFreqGovernor = "performance";

  hardware.cpu.amd.updateMicrocode = true; # AMD CPU
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true; # Mesa / OpenGL
    enable32Bit = true; # Vulkan 32 bit support
    extraPackages = with pkgs; [
      rocmPackages.clr.icd # AMD OpenCL
      amdvlk # AMDGPU vulkan
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk # AMDGPU vulkan 32 bit support
    ];
  };

  systemd.tmpfiles.rules = let
  
  in [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    #"f+ /run/gdm/.config/monitors.xml - gdm gdm - ${}"
  ];

  # DEFAULT screen setup
  services.xserver.xrandrHeads = [
    {
      output = "DisplayPort-1";
      primary = true;
      monitorConfig = ''
        Option "Position" "2560 0"
        Option "Enable" "true"
        Option "Rotate" "normal"
        Option "PreferredMode" "2560x1440_144"
      '';
    }
    {
      output = "DisplayPort-0";
      monitorConfig = ''
        Option "Position" "0 0"
        Option "Enable" "true"
        Option "Rotate" "normal"
        Option "PreferredMode" "2560x1440_144"
      '';
    }
  ];
}
