{ lib, config, pkgs, home-manager, ...}:

{

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

  # Configure Gnome settings for the user
  dconf.settings = {
      "org/gnome/calculator" = {
      };
  };

  # Configure Git for the user
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
      init = {
        defaultBranch = "master";
      };
      pull = {
        rebase = false;
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      delta = {
        navigate = false;
        light = false;
        hyperlinks = true;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
      push = {
        autoSetupRemove = true;
      };
      filter = {
        lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
    };
  };

  home.file."test-file".text = "test file content";

  # Configure bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      if [[ $- != *i* ]] ; then
              # Shell is non-interactive.  Be done now!
              return
      fi
      set -o vi

      eval "$(atuin init bash --disable-up-arrow)"
      eval "$(starship init bash)"
      eval "$(zoxide init bash --cmd cd)"

      if [ -d $HOME/.venv ]; then
          source ~/.venv/bin/activate
      fi

      alias ll='eza -lahg --git-repos-no-status --git'
      alias ls='eza'
      alias cat='bat --paging=never --style=plain'
    '';
  };

}
