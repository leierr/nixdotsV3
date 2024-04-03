{ cfg, pkgs, lib, config }:
{
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = cfg.grub.useOSProber;
      theme = pkgs.stdenv.mkDerivation {
        name = "grub_theme";
        src = builtins.fetchGit {
          url = "https://github.com/AdisonCavani/distro-grub-themes.git";
          ref = "master";
        };
        installPhase = "tar -xf themes/nixos.tar -C $out";
      };
    };

    efi.canTouchEfiVariables = true;
    timeout = 5;
  };
}
