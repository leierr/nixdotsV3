{ useOSProber, configurationLimit }:
{
  grub = {
    boot.loader = {
      grub = {
        enable = true;
        efiSupport = true;
        inherit useOSProber;
        inherit configurationLimit;
      };

      efi = {
        canTouchEfiVariables = true;
      };

      timeout = 3;
    };
  };

  systemd_boot = {
    boot.loader = {
      grub.enable = false;

      systemd-boot = {
        enable = true;
        editor = true;
        inherit configurationLimit;
      };

      efi = {
        canTouchEfiVariables = true;
      };

      timeout = 3;
    };
  };
}
