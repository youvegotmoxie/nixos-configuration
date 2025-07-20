{ lib, config, pkgs, home-manager, ...}:

{

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

  dconf.settings = {
      "org/gnome/calculator" = {
      };
  };

  programs.git = {
    userName = "MikeB";
    userEmail = "youvegotmoxie@gmail.com";
  };

}
