{
  description = "snafu-nixos system flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, sops-nix, ... }@inputs:
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
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs.flake-inputs = inputs;
              home-manager.users.mike.home.stateVersion = "25.05";
              # Use Home Manager to manage Flatpaks
              home-manager.users."mike".imports = [
                nix-flatpak.homeManagerModules.nix-flatpak
                # Flatpak NixOS configuration
                ./users/flatpak.nix
                ./users/home.nix
              ];
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
