{
  lib,
  pkgs,
  config,
  ...
}: {
  # Create user's main group
  users.groups."mike" = {};

  # Create user
  users.users."mike" = {
    isNormalUser = true;
    group = "mike";
    extraGroups = ["wheel" "users" "qemu-libvirtd" "docker"];
    shell = pkgs.bash;
    home = "/home/mike";
    createHome = true;
    description = "mike";
  };

  # Install and configure Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  sops.secrets.gh_token = {
    path = "${config.sops.defaultSymlinkPath}/gh_token";
  };
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
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
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };

  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/youvegotmoxie/nixos-ansible.git";
        branches.main.name = "master";
        auth.access_token_path = "${config.sops.secrets.gh_token.path}";
      }
    ];
  };

  # Install Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    storageDriver = "btrfs";
    rootless = {
      enable = false;
      setSocketVariable = false;
    };
  };
}
