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
      programs.zsh.enable = true;
      home_manager_modules = [
        ({
          programs.zsh = {
            enable = true;
            oh-my-zsh.enable = lib.mkIf cfg.zsh.ohMyZsh.enable true;
            oh-my-zsh.plugins = [];
            syntaxHighlighting.enable = true;
            autosuggestion.enable = true;
            envExtra = ''
              ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=246"
            '';
            history.save = 690000;
            history.size = 690000;
          };
        })
      ];
    })

    # Starship
    (lib.mkIf cfg.starship.enable { programs.starship.enable = true; })

    # VIM
    (lib.mkIf ( cfg.editor == "vim" ) { programs.vim.defaultEditor = true; })

    # NEOVIM
    (lib.mkIf ( cfg.editor == "neovim" ) {
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
