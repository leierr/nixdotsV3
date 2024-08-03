{ pkgs, lib, config, ... }:

let
  cfg = config.system_settings.gui.cursor;
in
{
  options.system_settings.gui.cursor.enable = lib.mkEnableOption "";

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    services.xserver.displayManager.lightdm.greeters.gtk.cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 32;
    };

    home_manager_modules = [
      ({
        home.pointerCursor = {
          name = "Adwaita";
          size = 32;
          package = pkgs.adwaita-icon-theme;
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
