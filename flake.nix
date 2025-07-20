{
  description = "snafu-nixos system flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ...}:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      snafu-nixos = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
           # Import the main module
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mike = "./users/mike.nix";
          }
        ];
      };
    };
  };
}
