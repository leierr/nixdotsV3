{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    # extra providers
    withPython3 = false;
    withNodeJs = false;
    withRuby = false;
  };
}
