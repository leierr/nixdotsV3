{ pkgs, lib, config, ... }:

let
  cfg = config.system_settings.gui.cursor;
in
{
  options.system_settings.gui.cursor.enable = lib.mkEnableOption "";

  config = lib.mkIf (cfg.enable) {
    services.xserver.displayManager.lightdm.greeters.gtk.cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
      size = 32;
    };

    home_manager_modules = [
      ({
        home.pointerCursor = {
          name = "Adwaita";
          size = 32;
          package = pkgs.gnome.adwaita-icon-theme;
          x11 = {
            enable = true;
            defaultCursor = "left_ptr";
          };
          gtk.enable = true;
        };

        wayland.windowManager.hyprland.settings.env = [
          "HYPRCURSOR_THEME,Adwaita"
          "HYPRCURSOR_SIZE,32"
        ];

        wayland.windowManager.hyprland.settings.exec-once = [
          "hyprctl setcursor Adwaita 32"
        ];
      })
    ];
  };
}
