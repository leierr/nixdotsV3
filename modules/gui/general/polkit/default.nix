{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.polkit;
in
{
  options.system_settings.gui.polkit.enable = lib.mkEnableOption "";

  config = lib.mkIf (cfg.enable) {
    security.polkit.enable = true;
  };
}
