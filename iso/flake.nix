{
  description = "Minimal NixOS installation media";
  inputs.nixos.url = "nixpkgs-unstable";
  outputs = { self, nixos }: {
    nixosConfigurations = {
      minimal_iso = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./configuration.nix
        ];
      };
    };
  };
}
