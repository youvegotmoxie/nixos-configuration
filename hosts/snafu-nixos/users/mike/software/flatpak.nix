{
  services.flatpak.uninstallUnmanaged = true;
  services.flatpak.update.auto.enable = true;

  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
  ];
}
