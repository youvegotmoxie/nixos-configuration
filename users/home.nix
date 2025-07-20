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
    enable = true;
    userName = "MikeB";
    userEmail = "youvegotmoxie@gmail.com";
    signing.key = "~/.ssh/id_rsa.pub";
    extraConfig = {
      core = {
        pager = "delta --pager=never --max-line-length=0";
        editor = "nvim";
      };
    };
  };

}
