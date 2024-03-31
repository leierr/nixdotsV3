{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.mlocate;
in
{
  options.system_settings.mlocate.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    services.locate = {
      enable = true;
      localuser = null; # silence warning
      package = pkgs.mlocate;
      interval = "*-*-* 14:00:00"; # every day @ 14:00
    };
  };
}
