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

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ...}@inputs:
    let
     system = "x86_64-linux";
    in
    {
    nixosConfigurations = {
      snafu-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
           # Import the main module
          ./configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs.flake-inputs = inputs;
            home-manager.users.mike.home.stateVersion = "25.05";
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
