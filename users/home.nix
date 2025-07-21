{ lib, config, pkgs, home-manager, ... }:

{

  # Per-application NixOS configuration
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

  # Configure home-manager
  programs.home-manager.enable = true;
  services.home-manager.autoExpire.enable = true;

  # Setup backups
  services.restic = {
    enable = true;
  };

  # Do this instead of setting up Chezmoi
  home.file.".pre-commit.yaml".text = ''
    # See https://pre-commit.com for more information
    # See https://pre-commit.com/hooks.html for more hooks
    repos:
    - repo: https://github.com/pre-commit/pre-commit-hooks
      rev: v5.0.0
      hooks:
      - id: trailing-whitespace
      - id: check-added-large-files
      - id: end-of-file-fixer
    - repo: https://github.com/hhatto/autopep8
      rev: 'v2.3.2'
      hooks:
      - id: autopep8
    - repo: https://github.com/gitleaks/gitleaks.git
      rev: 'v8.26.0'
      hooks:
      - id: gitleaks
    - repo: https://github.com/koalaman/shellcheck-precommit
      rev: v0.10.0
      hooks:
      - id: shellcheck
        exclude: .*jenkins-slave$
    - repo: https://github.com/hadolint/hadolint
      rev: v2.13.1-beta
      hooks:
      - id: hadolint-docker
        args:
        - --ignore=DL3015 # Ignore not using --no-install-recommends with apt
        - --ignore=DL3008 # Ignore not pinning all software package versions (apt-get)
        - --ignore=DL3018 # Ignore not pinning all software package versions (apk)
        - --ignore=SC1091 # Ignore missing shellcheck mock files
    - repo: https://github.com/gruntwork-io/pre-commit
      rev: 'v0.1.29'
      hooks:
      - id: terraform-validate'';


  # Set EDITOR to nvim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

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
    gh
    ghostty
    go
    jdk21_headless
    jq
    lazydocker
    lazygit
    nodejs
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
