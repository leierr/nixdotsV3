{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.gui.rofi;
  theme = config.system_settings.gui.theme;
in
{
  options.system_settings.gui.rofi = {
    enable = lib.mkEnableOption "";
    drun_exec = lib.mkOption { type = lib.types.str; default = "rofi -show drun -config ~/.config/rofi/drun.rasi"; };
    plugins.rbw.enable = lib.mkEnableOption "";
    plugins.rbw.exec = lib.mkOption { type = lib.types.package; default = pkgs.writeShellScriptBin "rofi-rbw" ''
      #!/usr/bin/env bash

      if [[ -n ''${WAYLAND_DISPLAY} && ''${XDG_SESSION_TYPE} == "wayland" ]]
      then
          clipboard_utility="wl-copy"
      else
          clipboard_utility="xclip -i -selection c"
      fi

      rbw unlock
      passphrase=$(rbw list | rofi -dmenu -i -config ~/.config/rofi/rbw.rasi | xargs -I{} rbw get "{}")
      [[ -n "$passphrase" ]] && echo -n $passphrase | ''${clipboard_utility}
      unset passphrase
    ''; };
  };

  config = lib.mkIf (cfg.enable && config.system_settings.gui.enable) (lib.mkMerge [
    {
      environment.systemPackages = with pkgs; [
      # dependencies to run correctly
      rofi-wayland
      hack-font
      nerdfonts
      papirus-icon-theme
    ];}

    ( import ./configs/theme.nix { inherit theme; })
    ( import ./configs/drun.nix )
    ( lib.mkIf cfg.plugins.rbw.enable (import ./configs/rbw.nix { inherit pkgs config; }) )
  ]);
}
