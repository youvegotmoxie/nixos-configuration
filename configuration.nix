{ config, lib, pkgs, ... }:

{
  # Add config file imports
  imports =
    [
      ./hardware-configuration.nix
      ./users/mike.nix
      ./filesystems.nix
      ./desktop/gnome.nix
    ];

  # Bootloader and kernel configuration
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Set hostname and configure networking
  networking = {
    hostName = "snafu-nixos";
    networkmanager.enable = true;
  };
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [{ from = 1716; to = 1764; }];
    allowedUDPPortRanges = [{ from = 1716; to = 1764; }];
  };

  # TZ and localization settings
  time.timeZone = "America/Anchorage";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable system services
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  services.openssh.enable = true;

  # Set NixOS specific env vars
  environment = {
    sessionVariables = rec {
      NIXOS_OZONE_WL = "1";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_BIN_HOME = "$HOME/.local/bin";
      PATH = [
        "${XDG_BIN_HOME}"
      ];
    };
  };

  # Globally installed packages
  environment.systemPackages = with pkgs; [
    btop
    clang
    git
    home-manager
    lsb-release
    nh
    python3
    pinentry-curses
    restic
    rocmPackages.rocm-smi
    sops
    unzip
    vim
    wget
  ];

  # Install and configure Flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Allow non-root use of restic
  users.users.restic = {
    isNormalUser = true;
  };
  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  # Install and enable GDM (login manager)
  services.displayManager.gdm.enable = true;
  services.power-profiles-daemon.enable = true;

  # NixOS system settings
  system.stateVersion = "25.05";
  # Not compatible with flakes
  system.copySystemConfiguration = false;

  # Add rocmSupport to all Nix packages. Fixes no GPU stats in btop
  # Allow unfree software
  nixpkgs.config = {
    rocmSupport = true;
    allowUnfree = true;
  };

  # Allow wheel group passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # Configure audio, keyboard, bluetooth and controllers
  hardware = {
    bluetooth.enable = true;
    xone.enable = true;
  };

  # Let Nix manage Nix
  nix.package = pkgs.nix;
  # Internal NixOS confguration
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    allowed-users = [
      "@wheel"
    ];
  };
}
