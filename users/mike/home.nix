{
  pkgs,
  lib,
  self,
  ...
}: let
  restic_passwd_path = "/backups/snafu-nixos/password.txt";
  password = builtins.readFile "${self}/halloy_ident";
in {
  # Per-application NixOS configuration
  imports = [
    ./software/atuin.nix
    ./software/bash.nix
    ./software/btop.nix
    ./software/ghostty.nix
    ./software/git.nix
    ./software/halloy.nix
    ./software/starship.nix
    ./software/zoxide.nix
  ];

  # Set home defaults
  home.username = "mike";
  home.homeDirectory = "/home/mike";

  # Configure sops
  # TODO: Ansible the manual setup portion of this
  # TODO: Use sops-nix template placeholder feature for seeding secrets
  sops = {
    age = {
      keyFile = "/home/mike/.config/sops/age/keys.txt";
      sshKeyPaths = ["/home/mike/.ssh/sops_ed25519"];
    };
    # Relative to home.nix config file: /etc/nixos/users/secrets/global.yaml
    defaultSopsFile = ./secrets/global.yaml;
  };

  # Setup secrets
  sops.secrets.restic_password = {path = "${restic_passwd_path}";};
  sops.secrets.halloy_ident = {
    path = "./halloy_ident";
  };

  # Configure home-manager
  programs.home-manager.enable = true;

  # Configure backups
  services.restic.enable = true;
  services.restic.backups = {
    "etc_nixos" = {
      initialize = true;
      passwordFile = "${restic_passwd_path}";
      pruneOpts = ["--keep-hourly 6" "--keep-daily 7" "--keep-weekly 4" "--keep-monthly 12"];
      paths = ["/etc/nixos"];
      repository = "/backups/snafu-nixos/etc_nixos";
      timerConfig = {
        OnCalendar = "hourly";
        RandomizedDelaySec = "10m";
      };
      extraBackupArgs = ["--cleanup-cache"];
    };
    "home_mike" = {
      initialize = true;
      exclude = [
        "/home/mike/.local/share/Steam"
        "/home/mike/Downloads"
        "/home/mike/.cache"
        "/home/mike/.cargo"
        "/home/mike/.local/share/gnome-boxes"
        "/home/mike/.local/share/docker"
      ];
      passwordFile = "${restic_passwd_path}";
      pruneOpts = ["--keep-daily 3" "--keep-weekly 2" "--keep-monthly 1"];
      paths = ["/home/mike"];
      repository = "/backups/snafu-nixos/mike";
      timerConfig = {
        OnCalendar = "daily";
        RandomizedDelaySec = "1h";
      };
      extraBackupArgs = ["--cleanup-cache"];
    };
  };

  home.file.".var/app/org.squidowl.halloy/config/halloy/config.toml".text = ''
    [servers.liberachat]
    nickname = "youvegotmoxie"
    password = ${password}
    server = "irc.libera.chat"
    channels = ["#halloy"]

    [buffer.channel.topic]
    enabled = true

    [actions.sidebar]
    buffer = "replace-pane"

    [actions.buffer]
    click_channel_name = "replace-pane"
    click_username = "replace-pane"
  '';

  # Add public key and rules config
  home.file.".sops.yaml".text = ''
    keys:
      - &mike age1w2szqkpqpurah7sc88xx0z3j2m068w6gryh6qh2vvpd5s9rd8uusppwsjr
    creation_rules:
      - path_regex: secrets/[^/]+\.(yaml|json|env|ini)$
        key_groups:
          - pgp:
            age:
            - *mike
  '';

  # Do this instead of setting up Chezmoi
  home.file.".pre-commit-config.yaml".text = ''
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
      rev: 'v8.28.0'
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
      rev: 'v0.1.30'
      hooks:
      - id: terraform-validate'';

  # Set EDITOR to nvim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Setup direnv
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Install user packages
  home.packages = with pkgs; [
    atuin
    bat
    bfs
    bitwarden
    bitwarden-cli
    brave
    cargo
    clang
    delta
    eza
    fd
    gh
    ghostty
    git
    go
    jdk21_headless
    jq
    lazydocker
    lazygit
    networkmanagerapplet
    nh
    nodejs
    python313
    ripgrep
    starship
    tree
    ugrep
    unzip
    viddy
    yq
    zoxide
    gnome-boxes
  ];
}
