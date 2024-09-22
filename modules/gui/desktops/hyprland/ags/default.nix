{ pkgs }:
{
  environment.systemPackages = [ pkgs.ags ];

  home_manager_modules = [
    ({
      home.file.".config/ags" = {
        source = ./config;
        recursive = true;
      };
    })
  ];
}