{ config, pkgs, ... }:
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

  boot.initrd.kernelModules = [ "i915" "xhci_pci" "nvme" "iwlwifi" "uvcvideo" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = with pkgs; [
    intel-vaapi-driver.override { enableHybridCodec = true; } # what is this?
    intel-media-driver # what is this?
  ];

  hardware.cpu.intel.updateMicrocode = true;

  hardware.trackpoint.enable = true;
  # hardware.trackpoint.sensitivity = 200;

  services.fstrim.enable = true; # SSD optimization
  services.fwupd.enable = true;  # Firmware updates

  #services.logind.extraConfig = ''
  #  HandleSuspendKey=suspend
  #  HandleLidSwitch=suspend
  #  HandleHibernateKey=hibernate
  #'';
}
