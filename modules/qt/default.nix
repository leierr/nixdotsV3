{ pkgs, lib, config, ... }:
let
  cfg = config.system_settings.qt;
in {
  options.system_settings.qt = {
    enable = lib.mkEnableOption null;
  };

  config = lib.mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    home_manager_modules = [
      ({...}: {
        qt = {
          enable = true;
          platformTheme = "gnome";
          style.name = "adwaita-dark";
        };
      })
    ];
  };
}
