{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.gaming;
in
{
  options.system_settings.gui.gaming = {
    enable = lib.mkEnableOption "";
    steam.enable = lib.mkOption { type = lib.types.bool; default = true; };
    lutris.enable = lib.mkOption { type = lib.types.bool; default = true; };
  };

  config = lib.mkIf cfg.enable {
    # Gaming
    programs.steam = lib.mkIf cfg.steam.enable {
      enable = true;
    };
    
    environment.systemPackages = lib.mkIf cfg.lutris.enable [
      pkgs.lutris
    ];
  };
}
