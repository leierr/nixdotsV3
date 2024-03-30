{ config, lib, ... }:

let
  cfg = config.system_settings.bluetooth;
in
{
  options.system_settings.bluetooth = {
    enable = lib.mkEnableOption "";
    enable_on_boot = lib.mkOption { type = lib.types.bool; default = true; };
  };

  config = lib.mkIf cfg.enable {
    # enables support for Bluetooth
    hardware.bluetooth.enable = true;
    # powers up the default Bluetooth controller on boot
    hardware.bluetooth.powerOnBoot = cfg.enable_on_boot;
  };
}
