{ config, lib, inputs, ... }:

let
  cfg = config.system_settings.nixos;
in
{
  options.system_settings.nixos = {
    enable = lib.mkEnableOption null;

    allow_unfree = lib.mkEnableOption null;

    unstable_packages_overlay = lib.mkOption { type = lib.types.bool; default = true; };

    permitted_insecure_packages = lib.mkOption { type = lib.types.listOf lib.types.singleLineStr; default = []; };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config = {
      allowUnfree = cfg.allow_unfree;
      permittedInsecurePackages = cfg.permitted_insecure_packages;
    };

    # make unstable packages available as an nixpkgs overlay
    nixpkgs.overlays = lib.mkIf cfg.unstable_packages_overlay [
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = config.nixpkgs.system;
          config = config.nixpkgs.config;
        };
      })
    ];
  };
}
