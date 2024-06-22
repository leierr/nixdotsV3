{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.boot_loader;
in
{
  options.system_settings.boot_loader = {
    enable = lib.mkEnableOption "";

    program = lib.mkOption { type = lib.types.enum [ "grub" "systemd_boot" ]; default = "grub"; };

    grub.useOSProber = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # Extra generic config
    { boot.tmp.cleanOnBoot = true; }

    # GRUB UEFI + THEME
    (lib.mkIf (cfg.program == "grub") (import ./grub.nix { inherit cfg pkgs; }) )

    # SYSTEMDBOOT UEFI
    (lib.mkIf (cfg.program == "systemd_boot") (import ./systemd_boot.nix))
  ]);
}
