{ cfg, pkgs, lib, config }:
{
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = cfg.grub.useOSProber;
      theme = pkgs.stdenv.mkDerivation {
        name = "hyperfluent_grub_theme";
        src = pkgs.fetchFromGitHub {
          owner = "Coopydood";
          repo = "HyperFluent-GRUB-Theme";
          rev = "b21a28079ab7fce57ee9080e2d09533262ef73fd";
          hash = "sha256-MWM6LQKtU5IWHx+s5MStPqeBd0jJRYYwB4zxGCBj1mA=";
        };
        installPhase = "cp -r nixos $out";
      };
    };

    efi.canTouchEfiVariables = true;
    timeout = 5;
  };
}
