{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.polkit;
in
{
  options.system_settings.polkit.enable = lib.mkEnableOption "";

  config = lib.mkIf (cfg.enable) {
    security.polkit.enable = true;
  };
}
