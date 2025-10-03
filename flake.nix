{
  description = "snafu-nixos system flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil.url = "github:oxalica/nil";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    comin,
    nixpkgs,
    home-manager,
    nix-flatpak,
    sops-nix,
    nil,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    comin_path = "/backups/snafu-nixos/gh_token";
    mainUser = "mike";
  in {
    nixosConfigurations = {
      snafu-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Import the main module
          ./hosts/snafu-nixos/configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          comin.nixosModules.comin
          {
            sops = {
              age = {
                keyFile = "/home/${mainUser}/.config/sops/age/keys.txt";
                sshKeyPaths = ["/home/${mainUser}/.ssh/sops_ed25519"];
              };
              # Relative to home.nix config file: /etc/nixos/users/secrets/global.yaml
            };
            sops.defaultSopsFile = ./hosts/snafu-nixos/users/${mainUser}/secrets/global.yaml;
            sops.secrets.gh_token = {
              path = "${comin_path}";
            };
            # Setup GitOps. Disabled for now due to excessive rebuilds
            services.comin = {
              enable = false;
              remotes = [
                {
                  name = "nixos-configuration";
                  url = "https://github.com/youvegotmoxie/nixos-configuration.git";
                  branches.main.name = "master";
                  auth.access_token_path = "${comin_path}";
                  poller.period = 300;
                }
              ];
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Move conflicting files out of the way instead of crashing home-manager
            home-manager.backupFileExtension = "hmback";
            home-manager.extraSpecialArgs.flake-inputs = inputs;
            home-manager.users."${mainUser}" = {
              home.stateVersion = "25.05";
              imports = [
                # Add sops-nix support for home-manager
                sops-nix.homeManagerModules.sops
                # Flatpak NixOS configuration
                nix-flatpak.homeManagerModules.nix-flatpak
                # Use Home Manager to manage Flatpaks
                ./hosts/snafu-nixos/users/${mainUser}/software/flatpak.nix
                # Main home-manager configuration
                ./hosts/snafu-nixos/users/${mainUser}/home.nix
              ];
            };
          }
        ];
        specialArgs = {inherit inputs;};
      };
    };
  };
}
