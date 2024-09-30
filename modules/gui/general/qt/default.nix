{ pkgs, lib, config, ... }:

let
  cfg = config.system_settings.gui.qt;
in
{
  options.system_settings.gui.qt = {
    enable = lib.mkEnableOption "";

    platformTheme = {
      name = lib.mkOption {
        type = lib.types.singleLineStr;
        default = "adwaita";
      };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = with pkgs; [ qgnomeplatform qgnomeplatform-qt6 ];
      };
    };

    style = {
      name = lib.mkOption {
        type = lib.types.singleLineStr;
        default = "adwaita-dark";
      };

      packages = lib.mkOption { 
        type = lib.types.listOf lib.types.package; 
        default = with pkgs; [ adwaita-qt adwaita-qt6 ];
      };
    };
  };

  config = lib.mkIf (cfg.enable) {
    # install dependencies
    environment.systemPackages = lib.lists.concatLists [
      cfg.style.packages
      cfg.platformTheme.packages
    ];

    qt = {
      enable = true;
      style = cfg.style.name;
    };

    home_manager_modules = [
      ({
        qt = {
          enable = true;
          platformTheme.name = cfg.platformTheme.name;
          style.name = cfg.style.name;
        };
      })
    ];
  };
}
