{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.gaming;
in
{
  options.system_settings.gui.gaming = {
    enable = lib.mkEnableOption "";
    steam.enable = lib.mkOption { type = lib.types.bool; default = true; };
    steam.package = lib.mkOption { type = lib.types.package; default = pkgs.steam; };
  };

  config = lib.mkIf cfg.enable {
    # Gaming
    programs.steam = lib.mkIf cfg.steam.enable {
      enable = true;
      package = cfg.steam.package;
    };
  };
}
