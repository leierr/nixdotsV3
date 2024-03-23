{ pkgs, lib, config, osConfig, ... }:
let
  cfg = config.home_manager_modules.gui.cursor;
in {
  options.home_manager_modules.gui.cursor = {
    enable = lib.mkOption { type = lib.types.bool; default = true; };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    services.xserver.displayManager.lightdm.greeters.gtk.cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 32;
    };

    home_manager_modules = [
      ({
        pointerCursor = {
          name = "Adwaita";
          size = 32;
          package = pkgs.gnome.adwaita-icon-theme;
          x11 = {
            enable = true;
            defaultCursor = "left_ptr";
          };
          gtk.enable = true;
        };
      })
    ];
  };
}
