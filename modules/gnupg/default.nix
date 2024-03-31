{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.terminal_utils;
in
{
  options.system_settings.terminal_utils = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };
  };
}
