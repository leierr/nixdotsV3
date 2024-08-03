{ pkgs, lib, config, ... }:

let
  cfg = config.system_settings.gui.gtk;
in
{
  options.system_settings.gui.gtk = {
    enable = lib.mkEnableOption "";

    font = {
      name = lib.mkOption {
        type = lib.types.singleLineStr;
        default = "gnome";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.cantarell-fonts;
      };

      size = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
      };
    };

    theme = {
      name = lib.mkOption {
        type = lib.types.singleLineStr;
        default = "Adwaita";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.libadwaita;
      };
    };

    icon_theme = {
      name = lib.mkOption {
        type = lib.types.singleLineStr;
        default = "Papirus-Dark";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.papirus-icon-theme;
      };
    };

    bookmarks = lib.mkOption { type = lib.types.listOf lib.types.singleLineStr; default = []; };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) {
    # dependencies
    programs.dconf.enable = true;

    home_manager_modules = [
      ({...}@inputs: {
        gtk = {
          enable = true;

          # denne er skummel å leke med. Driter i size og setter en classic gnome default font her.
          font = {
            name = cfg.font.name;
            package = cfg.font.package;
            size = cfg.font.size;
          };

          theme = {
            name = cfg.theme.name;
            package = cfg.theme.package;
          };

          iconTheme = {
            name = cfg.icon_theme.name;
            package = cfg.icon_theme.package;
          };

          # fuck gtk2, outdated fucker
          gtk2 = {
            configLocation = "${inputs.config.xdg.configHome}/gtk-2.0/gtkrc";
            extraConfig = ''
              # dark theme - hell yea
              gtk-application-prefer-dark-theme = 1

              # sounds
              gtk-error-bell = 1
              gtk-enable-input-feedback-sounds = 1
              gtk-enable-event-sounds = 1

              # disable recent file history
              gtk-recent-files-limit = 0
              gtk-recent-files-max-age = 0

              # other stuff
              gtk-enable-animations = 1
            '';
          };

          gtk3 = {
            bookmarks = cfg.bookmarks; # for GTK file browsers mainly
            extraConfig = {
              # dark theme - hell yea
              gtk-application-prefer-dark-theme = 1;
              #
              gtk-enable-animations = 1;
              gtk-enable-primary-paste = 0; # middle click on a mouse should paste the ‘PRIMARY’ clipboard
              gtk-recent-files-enabled = 0; # unnecessary
              # sound shit
              gtk-enable-event-sounds = 1;
              gtk-enable-input-feedback-sounds = 1;
              gtk-error-bell = 1;
            };
            extraCss = '''';
          };

          gtk4 = {
            extraConfig = {
              # dark theme - hell yea
              gtk-application-prefer-dark-theme = 1;
              #
              gtk-enable-animations = 1;
              gtk-enable-primary-paste = 0; # middle click on a mouse should paste the ‘PRIMARY’ clipboard
              gtk-recent-files-enabled = 0; # unnecessary
              # sound shit
              gtk-enable-event-sounds = 1;
              gtk-enable-input-feedback-sounds = 1;
              gtk-error-bell = 1;
            };
            extraCss = '''';
          };
        };
      })
    ];
  };
}
