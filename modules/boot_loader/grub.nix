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
        src = pkgs.fetchFromGitHub {
          owner = "AdisonCavani";
          repo = "distro-grub-themes";
          rev = "c96f868e75707ea2b2eb2869a3d67bd9c151cee6";
          hash = "sha256-QHqsQUEYxa04je9r4FbOJn2FqRlTdBLyvwZXw9JxWlQ=";
        };
        installPhase = ''
          mkdir -p $out
          tar -xf themes/nixos.tar -C $out
        '';
      };
    };

    efi.canTouchEfiVariables = true;
    timeout = 5;
  };
}
