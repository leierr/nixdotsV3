{ pkgs, lib, config, ... }:

let
  cfg = config.system_settings.gui.cursor;
in
{
  options.system_settings.gui.cursor.enable = lib.mkEnableOption "";
  options.system_settings.gui.cursor.size = 24;

  config = lib.mkIf (cfg.enable) {
    services.xserver.displayManager.lightdm.greeters.gtk.cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = cfg.size;
    };

    home_manager_modules = [
      ({
        home.pointerCursor = {
          name = "Adwaita";
          size = cfg.size;
          package = pkgs.gnome.adwaita-icon-theme;
          x11 = {
            enable = true;
            defaultCursor = "left_ptr";
          };
          gtk.enable = true;
        };

        wayland.windowManager.hyprland.settings.env = [
          "HYPRCURSOR_THEME,Adwaita"
          "HYPRCURSOR_SIZE,${cfg.size}"
        ];

        wayland.windowManager.hyprland.settings.exec-once = [
          "hyprctl setcursor Adwaita ${cfg.size}"
        ];
      })
    ];
  };
}
