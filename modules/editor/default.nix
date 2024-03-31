{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.editor;
in
{
  options.system_settings.editor = {
    enable = lib.mkEnableOption "";
    program = lib.mkOption { type = lib.types.enum [ "neovim" "vim" ]; default = "vim"; };
  };

  config = lib.mkIf cfg.enable lib.mkMerge ([
    (lib.mkIf (cfg.editor == "neovim") (import ./editors/neovim.nix))
    (lib.mkIf (cfg.editor == "vim") (import ./editors/vim.nix))
  ]);
}
