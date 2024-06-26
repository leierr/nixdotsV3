{ config, lib, inputs, ... }:

let
  cfg = config.system_settings.nixos;
in
{
  options.system_settings.nixos = {
    enable = lib.mkEnableOption "";
    garbage_collection.automatic = lib.mkOption { type = lib.types.bool; default = true; };
    allow_unfree = lib.mkOption { type = lib.types.bool; default = true; };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.hostPlatform = config.nixpkgs.system;

    nixpkgs.config.allowUnfree = lib.mkIf cfg.allow_unfree true;

    nix = {
      gc = lib.mkIf cfg.garbage_collection.automatic {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
      };

      # Thanks to: https://nixos-and-flakes.thiscute.world/best-practices/nix-path-and-flake-registry#custom-nix-path-and-flake-registry
      registry.nixpkgs.flake = inputs.nixpkgs; # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
      channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
    };
  };
}
