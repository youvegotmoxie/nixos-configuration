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
    virt-manager
  ];

  dconf.settings = {
    {
      "org/gnome/calculator" = {
        button-mode = "programming";
        show-thousands = true;
        base = 10;
        word-size = 64;
        window-position = lib.hm.gvariant.mkTuple [100 100];
      };
    }
  };

}
