{ lib, config, pkgs, home-manager, ...}:

{

  home.packages = with pkgs; [
    obsidian
  ];

}
