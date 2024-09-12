{ config, lib, inputs, ... }:

let
  cfg = config.system_settings.nixos;
in
{
  options.system_settings.nixos = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.hostPlatform = config.nixpkgs.system;

    # make unstable packages available as an nixpkgs overlay
    nixpkgs.overlays = [
      (final: prev: {
        unstable = import inputs.nixpkgs_unstable {
          system = config.nixpkgs.system;
          config = config.nixpkgs.config;
        };
      })
    ];

    nixpkgs.config.allowUnfree = true;

    documentation.nixos.enable = false;

    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      settings = {
        auto-optimise-store = true;
        flake-registry = ""; # Disable global registry
        experimental-features = [ "nix-command" "flakes" ];
      };

      # Thanks to: https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry#custom-nix-path-and-flake-registry
      registry.nixpkgs.flake = inputs.nixpkgs; # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
      channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
      nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
    };
  };
}
