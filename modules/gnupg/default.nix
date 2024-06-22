{ config, lib, ... }:

let
  cfg = config.system_settings.cli.gnupg;
in
{
  options.system_settings.cli.gnupg.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };
  };
}
