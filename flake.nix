{
  description = "snafu-nixos system flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ...}:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      snafu-nixos = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
           # Import the main module
          ./configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
