{ lib, pkgs, theme }:
let
  hexColorPattern = "^#[0-9a-fA-F]{6}";
  # Function to generate SCSS variable declarations from theme attributes
  nixThemeToScssVariables = lib.concatStrings (lib.mapAttrsToList (name: value: 
    if lib.isString value && builtins.match hexColorPattern value != null then ''
      ''$${name}: ${value};
    '' else ""
  ) theme);
in
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

      home.file.".config/ags/style/sass/nix_theme.scss".text = nixThemeToScssVariables;
    })
  ];
}