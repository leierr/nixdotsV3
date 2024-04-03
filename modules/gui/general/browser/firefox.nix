{ cfg, pkgs, inputs }:

let
  install_firefox_extension = extension_name: builtins.fetchurl { url="https://addons.mozilla.org/firefox/downloads/latest/${extension_name}/latest.xpi"; };
in
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
        extensions = [
          inputs.firefox_extensions.ublock-origin
        ];
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
