{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.boot_loader;
  bootLoader_configs = import ./bootloaders.nix {
    useOSProber = config.system_settings.boot_loader.useOSProber;
  };
in
{
  options.system_settings.boot_loader = {
    enable = lib.mkEnableOption "";

    program = lib.mkOption { type = lib.types.enum [ "grub" "systemd_boot" ]; default = "grub"; };

    grub.useOSProber = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { boot.tmp.cleanOnBoot = true; }

    (lib.mkIf (cfg.program == "grub") (import ./grub.nix { inherit cfg pkgs config lib; }) )

    (lib.mkIf (cfg.program == "systemd_boot") (import ./systemd_boot.nix))
  ]);
}
