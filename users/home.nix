{ lib, config, pkgs, home-manager, ...}:

{

  home.packages = with pkgs; [
    ansible
    ansible-lint
    obsidian
  ];

}
