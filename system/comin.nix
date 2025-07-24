{
  pkgs,
  config,
}: {
  inputs = {
    nixpkgs.url = "github:nixOS/nixpkgs";
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    comin,
  }: {
    nixosConfigurations = {
      myMachine = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          comin.nixosModules.comin
          ({...}: {
            services.comin = {
              enable = true;
              remotes = [
                {
                  name = "origin";
                  url = "https://gitlab.com/your/infra.git";
                  branches.main.name = "main";
                }
              ];
            };
          })
        ];
      };
    };
  };
}
