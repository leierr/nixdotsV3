{ pkgs, theme }:
{
  environment.systemPackages = with pkgs; [
    ags

    # styling
    dart-sass
  ];

  # https://github.com/NixOS/nixpkgs/issues/306446
  nixpkgs.overlays = [
    (final: prev:
    {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ];
      });
    })
  ];

  home_manager_modules = [
    ({
      #home.file.".config/ags" = {
      #  source = ./config;
      #  recursive = true;
      #};
    })
  ];
}