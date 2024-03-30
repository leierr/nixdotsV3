{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.terminal_utils;
in
{
  options.system_settings.terminal_utils = {
    locate.enable = lib.mkEnableOption "";
    gnupg.enable = lib.mkEnableOption "";
    editor.program = lib.mkOption { type = lib.types.nullOr (lib.types.enum [ "neovim" "vim" ]); default = null; };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.locate.enable {
      # mlocate
      services.locate = {
        enable = true;
        localuser = null; # silence warning
        package = pkgs.mlocate;
        interval = "*-*-* 14:00:00"; # every day @ 14:00
      };
    })

    (lib.mkIf (cfg.gnupg.enable) (import ./gnupg.nix))

    (lib.mkIf (cfg.editor == "neovim") (import ./editors/neovim.nix))
    (lib.mkIf (cfg.editor == "vim") (import ./editors/vim.nix))
  ];
}
