{ config, lib, ... }:

let
  cfg = config.system_settings.cli.git;
in
{
  options.system_settings.cli.git.enable = lib.mkEnableOption "";

  config = lib.mkIf cfg.enable {
    programs.git.enable = true;
    home_manager_modules = [
      ({
        programs.git = {
          enable = true;
          extraConfig = {
            url."git@github.com:".insteadOf = "https://github.com/";
            extraConfig.credential.helper = "cache --timeout=36000";
          };
          includes = [];
        };
      })
    ];
  };
}
