{ config, lib, ... }:

let
  cfg = config.system_settings.boot_loader;
  bootLoader_configs = import ./bootloaders.nix {
    useOSProber = config.system_settings.boot_loader.useOSProber;
    configurationLimit = config.system_settings.boot_loader.configurationLimit;
  };
in
{
  options.system_settings.boot_loader = {
    enable = lib.mkEnableOption null;

    type = lib.mkOption { type = lib.types.enum [ "grub" "systemd_boot" ]; };

    useOSProber = lib.mkEnableOption null;

    configurationLimit = lib.mkOption {
      type = lib.types.int;
      default = 20;
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { boot.tmp.cleanOnBoot = true; }
    (lib.mkIf (cfg.type == "grub") bootLoader_configs.grub)
    (lib.mkIf (cfg.type == "systemd_boot") bootLoader_configs.systemd_boot)
  ]);
}
