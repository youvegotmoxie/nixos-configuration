{ lib, config, pkgs, home-manager, ... }:

{

  imports = [
    ./atuin.nix
    ./bash.nix
    ./btop.nix
    ./ghostty.nix
    ./git.nix
    ./starship.nix
    ./zoxide.nix
  ];

  # Set home defaults
  home.username = "mike";
  home.homeDirectory = "/home/mike";

  # Set EDITOR to nvim
  programs.neovim.defaultEditor = true;

  # Install user packages
  home.packages = with pkgs; [
    ansible
    ansible-lint
    atuin
    bat
    bfs
    bitwarden
    bitwarden-cli
    brave
    direnv
    delta
    eza
    fd
    ghostty
    go
    jdk21_headless
    jq
    lazydocker
    lazygit
    nodejs
    neovim
    pre-commit
    ripgrep
    starship
    tree
    ugrep
    uv
    viddy
    yq
    zoxide
    gnome-boxes
  ];

}
