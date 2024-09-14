{
  description = "leiers NixOS dotfiles V3";

  outputs = { nixpkgs, ... }@inputs:
    let
      mkSystem = {
        system ? "x86_64-linux",
        pkgs ? inputs.nixpkgs,
        home_manager ? inputs.home-manager.nixosModules.home-manager,
        host_name,
        system_state_version,
        configuration ? ( ./. + "/hosts/${host_name}/configuration.nix"),
        hardware_configuration ? ( ./. + "/hosts/${host_name}/hardware_configuration.nix")
      }: 
      pkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          configuration
          hardware_configuration
          ./modules
          home_manager
          { system.stateVersion = system_state_version; }
          { networking.hostName = host_name; }
        ];
      };
    in {
    nixosConfigurations = {
      desktop = mkSystem { host_name = "desktop"; system_state_version = "24.05"; };
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs_unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    #
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.41.2";
    split-monitor-workspaces = {
	    	url = "github:Duckonaut/split-monitor-workspaces";
	    	inputs.hyprland.follows = "hyprland";
		};
  };
}
