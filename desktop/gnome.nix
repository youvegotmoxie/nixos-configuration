{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gnome;
in {
  options.gnome = {
    enable = lib.mkEnableOption "Enable/disable";
    type = lib.mkOption {
      description = "true/false";
      type = lib.types.bool;
    };
    default = true;
  };
  config = lib.mkIf cfg.enable {
    services.desktopManager.gnome.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    environment.systemPackages = with pkgs; [
      gjs
      gnomeExtensions.blur-my-shell
      gnomeExtensions.bluetooth-file-sender
      gnomeExtensions.gsconnect
      gnomeExtensions.night-light-slider
      gnomeExtensions.user-avatar-in-quick-settings
      gnomeExtensions.user-themes
      gnome-browser-connector
      gnome-tweaks
      gnome-themes-extra
      chrome-gnome-shell
      gnome-shell-extensions
      kora-icon-theme
    ];

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-terminal
      gnome-text-editor
      gnome-music
      gnome-contacts
      epiphany
      geary
      evince
      totem
      cheese
      simple-scan
      xdg-desktop-portal-gtk
    ];

    # Install and configure Flatpak
    services.flatpak.enable = true;
  };
}
