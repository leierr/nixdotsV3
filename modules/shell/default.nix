{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.shell;
in
{
  options.system_settings.shell = {
    enable = lib.mkEnableOption "";
    starship.enable = lib.mkOption { type = lib.types.bool; default = true; };
    editor.enable = lib.mkOption { type = lib.types.bool; default = true; };
    editor.program = lib.mkOption { type = lib.types.enum [ "neovim" "vim" ]; default = "vim"; };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # addons
    (lib.mkIf cfg.starship.enable (import ./addons/starship.nix { inherit cfg; }))
    # editors
    (lib.mkIf (cfg.editor.program == "neovim") (import ./editors/neovim.nix))
    (lib.mkIf (cfg.editor.program == "vim") (import ./editors/vim.nix))
  ]);
}
