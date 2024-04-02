{
  description = "leiers NixOS dotfiles V3";

  outputs = { nixpkgs, ... }@inputs:
    let
      mkSystem = import ./lib/mksystem.nix;
    in {
    nixosConfigurations =  {
      desktop = mkSystem {
        inherit nixpkgs inputs;
        hostName = "desktop";
        system_state_version = "23.11";
      };
      workmachine = mkSystem {
        inherit nixpkgs inputs;
        hostName = "workmachine";
        system_state_version = "23.11";
      };
      test-vm = mkSystem {
        inherit nixpkgs inputs;
        hostName = "test-vm";
        system_state_version = "23.11";
      };
    };
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags.url = "github:Aylur/ags";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpaper.url = "github:hyprwm/hyprpaper";
    hypridle.url = "github:hyprwm/hypridle";
    hyprlock.url = "github:hyprwm/Hyprlock";
  };
}
