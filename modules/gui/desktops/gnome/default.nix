{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.system_settings.gui.desktops.gnome;
  theme = config.system_settings.gui.theme;
  hexToRGBA = (import (inputs.self + "/helper_functions/hex_to_rgba.nix") { inherit lib; });
in
{
  options.system_settings.gui.desktops.gnome = {
    enable = lib.mkEnableOption "";
  };

  config = {
    # install gnome globally
    services.xserver.desktopManager.gnome.enable = true;

    # cool nautilus picture/video previewer
    services.gnome.sushi.enable = true;
    environment.systemPackages = [ pkgs.gnome.nautilus pkgs.libappindicator pkgs.gnomeExtensions.appindicator pkgs.gnomeExtensions.dash-to-panel ];

    # disable most default gnome crap
    services.gnome.core-utilities.enable = false;
    environment.gnome.excludePackages = (with pkgs; [ gnome-tour ]);

    # tror dette er vanlig lmao
    programs.dconf.enable = true;
    programs.xwayland.enable = true;
    services.dbus.enable = true;
    services.gvfs.enable = true;

    # home manager stuff
    home_manager_modules = [
      ({
        dconf = {
          settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
          settings."org/gnome/mutter".edge-tiling = true;
          settings."org/gnome/desktop/interface".enable-hot-corners = false;
          settings."org/gnome/desktop/peripherals/touchpad".two-finger-scrolling-enabled = true;
          settings."org/gnome/system/location".enabled = false;
          settings."org/gnome/desktop/wm/preferences".resize-with-right-button = true;
          settings."org/gnome/desktop/wm/preferences".mouse-button-modifier = "<Super>";
          settings."org/gnome/mutter".center-new-windows = true;
          settings."org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";
          settings."org/gnome/mutter".dynamic-workspaces = true;
          settings."org/gnome/shell/app-switcher".current-workspace-only = true;
          settings."org/gnome/desktop/interface".enable-animations = false;

          # extensions
          settings."org/gnome/shell".disable-user-extensions = false;
          settings."org/gnome/shell".enabled-extensions = [
            pkgs.gnomeExtensions.appindicator.extensionUuid
            pkgs.gnomeExtensions.dash-to-panel.extensionUuid
          ];
          settings."org/gnome/shell/extensions/dash-to-panel".dot-style-unfocused = "DASHES";
          settings."org/gnome/shell/extensions/dash-to-panel".show-apps-icon-file = "${./assets/nixos.svg}";

          # bindings
          settings."org/gnome/desktop/wm/keybindings".close = [ "<Super>w" ];
          settings."org/gnome/desktop/wm/keybindings".switch-windows = [ "<Alt>Tab" ];
          settings."org/gnome/desktop/wm/keybindings".switch-windows-backward = [ "<Shift><Alt>Tab" ];
          settings."org/gnome/shell/keybindings".show-screenshot-ui = [ "<Super>q" ];

          # custom bindings
          settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>Return";
            command = "alacritty";
            name = "Terminal Emulator";
          };
          settings."org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];

          # unbind
          settings."org/gnome/desktop/wm/keybindings".switch-applications = [];
          settings."org/gnome/desktop/wm/keybindings".switch-applications-backward = [];
          settings."org/gnome/shell/keybindings".screenshot = [];
        };
      })
    ];
  };
}
