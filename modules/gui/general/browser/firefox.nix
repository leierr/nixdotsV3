{ cfg, pkgs }:
{
  home_manager_modules = [
    ({
      programs.firefox.enable = true;
      programs.firefox.package = pkgs.firefox;
      programs.firefox.profiles.main = {
        id = 0;
        name = "main";
        isDefault = true;
        bookmarks = [];
        extensions = [];
        settings = {};
        search = {
          default = "DuckDuckGo";
          privateDefault = "DuckDuckGo";
          engines = {}; # custom search engines
          order = [ "DuckDuckGo" "Google" ];
          force = true; # enforce the config defined here.
        };
      };
    })
  ];
}
