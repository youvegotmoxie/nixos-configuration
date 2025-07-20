{ config, lib, pkgs, ... }:

{

  # Create user's main group
  users.groups.mike = {};

  # Create user
  users.users.mike = {
    isNormalUser = true;
    group        = "mike";
    extraGroups  = [ "wheel" "users" "qemu-libvirtd" ];
    shell        = pkgs.bash;
    home         = "/home/mike";
    createHome   = true;
    description  = "mike";
    packages     = with pkgs; [
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
  };

  # Install and configure Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
  ];

  # Setup QEMU + KVM
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };
}
