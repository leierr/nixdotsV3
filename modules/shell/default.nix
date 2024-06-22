{ config, lib, pkgs, ... }:

let
  cfg = config.system_settings.shell;
in
{
  options.system_settings.shell = {
    enable = lib.mkEnableOption "";
    zsh.enable = lib.mkEnableOption "";
    zsh.ohMyZsh.enable = lib.mkOption { type = lib.types.bool; default = true; };
    starship.enable = lib.mkEnableOption "";
    editor = lib.mkOption { type = lib.types.enum [ "vim" "neovim" ]; default = "neovim"; };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge[
    # ZSH
    (lib.mkIf cfg.zsh.enable {
      programs.zsh = lib.mkIf cfg.zsh.enable {
        enable = true;
        histSize = 69000;
        syntaxHighlighting.enable = true;
        autosuggestions.enable = true;
        ohMyZsh.enable = lib.mkIf cfg.zsh.ohMyZsh.enable  true;
      };

      programs.zsh.interactiveShellInit = ''
        # ctrl + space
        bindkey '^ ' autosuggest-accept
      '';
    })

    # Starship
    (lib.mkIf cfg.starship.enable { programs.starship.enable = true; })

    # VIM
    (lib.mkIf cfg.starship.enable { programs.vim.defaultEditor = true; })

    # NEOVIM
    (lib.mkIf cfg.starship.enable {
      programs.neovim = {
        enable = true; viAlias = true; vimAlias = true; defaultEditor = true;
        withPython3 = false; withNodeJs = false; withRuby = false;
      };
    })
    
    # Increase Bash default history size
    {
      programs.bash.interactiveShellInit = ''
        HISTFILESIZE=69000
        HISTSIZE=69000
      '';
    }
  ]);
}
