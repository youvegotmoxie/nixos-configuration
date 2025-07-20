{ lib, config, pkgs, home-manager, ... }:

{
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

}
