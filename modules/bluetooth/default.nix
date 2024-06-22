{ config, lib, ... }:

let
  cfg = config.system_settings.bluetooth;
in
{
  options.system_settings.bluetooth = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    # enables support for Bluetooth
    hardware.bluetooth.enable = true;

    # powers up the default Bluetooth controller on boot
    hardware.bluetooth.powerOnBoot = true;
  };
}
