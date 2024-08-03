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
    environment.systemPackages = [ pkgs.gnome.nautilus ];

    # disable most default gnome crap
    services.gnome.core-utilities.enable = false;
    environment.gnome.excludePackages = (with pkgs; [ gnome-tour ]);

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

          # bindings
          settings."org/gnome/desktop/wm/keybindings".close = [ "<Super>w" ];
          settings."org/gnome/desktop/wm/keybindings".switch-windows = [ "<Alt>Tab" ];
          settings."org/gnome/desktop/wm/keybindings".switch-windows-backward = [ "<Shift><Alt>Tab" ];

          # unbind
          settings."org/gnome/desktop/wm/keybindings".switch-applications = [];
          settings."org/gnome/desktop/wm/keybindings".switch-applications-backward = [];
        };
      })
    ];
  };
}
