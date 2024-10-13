{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.xdg;
in
{
  options.system_settings.gui.xdg.enable = lib.mkEnableOption "";

  config = lib.mkIf (cfg.enable) {
    home_manager_modules = [
      ({ config, ... }:{
        xdg = {
          enable = true;
          userDirs = {
            enable = true;
            createDirectories = true;
            desktop = "${config.home.homeDirectory}/Desktop";
            documents = "${config.home.homeDirectory}/Documents";
            download = "${config.home.homeDirectory}/Downloads";
            music = "${config.home.homeDirectory}/Music";
            pictures = "${config.home.homeDirectory}/Pictures";
            publicShare = "${config.home.homeDirectory}/Public";
            templates = "${config.home.homeDirectory}/Templates";
            videos = "${config.home.homeDirectory}/Videos";
          };

          mimeApps = {
            enable = true;

            defaultApplications = {
              "x-scheme-handler/http" = [ "firefox.desktop" ];
              "x-scheme-handler/https" = [ "firefox.desktop" ];
              "x-scheme-handler/chrome" = [ "firefox.desktop" ];
              "text/html" = [ "firefox.desktop" ];
              "application/x-extension-htm" = [ "firefox.desktop" ];
              "application/x-extension-html" = [ "firefox.desktop" ];
              "application/x-extension-shtml" = [ "firefox.desktop" ];
              "application/xhtml+xml" = [ "firefox.desktop" ];
              "application/x-extension-xhtml" = [ "firefox.desktop" ];
              "application/x-extension-xht" = [ "firefox.desktop" ];

              # magnet links / torrenting
              "x-scheme-handler/magnet" = [ "transmission-gtk.desktop" ];
              "application/x-bittorrent" = [ "transmission-gtk.desktop" ];

              # Images
              "image/*" = [ "gthumb.desktop" ];

              # Videos
              "video/*" = [ "mpv.desktop" ];
            };
          };
        };
      })
    ];

    environment.systemPackages = with pkgs; [ gthumb firefox mpv transmission  ];
  };
}
