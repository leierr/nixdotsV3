{ config, lib, ... }:

let
  cfg = config.system_settings.git;
in
{
  options.system_settings.git = {
    enable = lib.mkEnableOption null;

    extraConfig = lib.mkOption {
      default = {
        url = {
          "git@github.com:" = { insteadOf = "https://github.com/"; };
        };

        credential = {
          helper = "cache --timeout=36000";
        };
      };
    };

    includes = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    home_manager_modules = [
      ({
        programs.git = {
          enable = true;

          extraConfig = cfg.extraConfig;

          includes = cfg.includes;
        };
      })
    ];
  };
}
