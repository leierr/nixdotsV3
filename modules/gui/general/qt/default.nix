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
        default = "gnome";
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

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    # install dependencies
    environment.systemPackages = lib.lists.concatLists [
      cfg.style.packages
      cfg.platformTheme.packages
    ];

    qt = {
      enable = true;
      platformTheme = cfg.platformTheme.name;
      style = cfg.style.name;
    };

    home_manager_modules = [
      ({
        qt = {
          enable = true;
          platformTheme = cfg.platformTheme.name;
          style.name = cfg.style.name;
        };
      })
    ];
  };
}
