{ lib, ... }:

{

  services.flatpak.uninstallUnmanaged = false;
  services.flatpak.update.auto.enable = false;

  services.flatpak.packages = [
    "com.discordapp.Discord"
    "com.github.tchx84.Flatseal"
    "com.todoist.Todoist"
  ];

}
