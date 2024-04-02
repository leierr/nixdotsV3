{ cfg, pkgs, lib, config }:
{
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = cfg.grub.useOSProber;
      theme = pkgs.fetchurl {
        url = "https://github.com/AdisonCavani/distro-grub-themes/releases/download/v3.2/nixos.tar";
        sha512="3ndh8yzyap3s8z0l3732cv5k66b40rfid1dy8dda72m78sdmbva5jq5ril76vgmy7pzdwhn8gyvbjgnzmfflfws5b0yj3fg72vfxcna";
        postFetch = ''tar -xf "$out"'';
      };
    };

    efi.canTouchEfiVariables = true;
    timeout = 5;
  };
}
