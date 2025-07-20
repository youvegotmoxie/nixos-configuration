{
  description = "snafu-nixos system flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ...}: 
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      snafu-nixos = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
