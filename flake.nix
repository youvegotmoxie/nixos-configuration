{
  description = "snafu-nixos system flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ...}:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      snafu-nixos = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
           # Import the main module
          ./configuration.nix
        ];
      };
    };
  };
}
