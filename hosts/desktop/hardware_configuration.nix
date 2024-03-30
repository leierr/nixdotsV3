{
  fileSystems."/" = {
    label = "NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    label = "NIXBOOT";
    fsType = "vfat";
  };

  swapDevices = [ ];
}
