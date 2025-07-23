{
  lib,
  pkgs,
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
    allowedBridges = ["br0"];
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
  systemd.network = {
    enable = true;
    netdevs = {
      "br0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
        };
      };
    };
    networks = {
      "30-enp35s0" = {
        matchConfig.Name = "enp35s0";
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "40-br0" = {
        matchConfig.Name = "br0";
        networkConfig = {
          DHCP = "ipv4";
        };
      };
    };
  };
}
