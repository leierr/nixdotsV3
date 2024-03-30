{
  boot.loader = {
    grub.enable = false;

    systemd-boot = {
      enable = true;
      editor = true;
    };

    efi.canTouchEfiVariables = true;
    timeout = 3;
  };
}
