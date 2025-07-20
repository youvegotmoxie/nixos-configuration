{ lib, ... }:

{

  services.flatpak.packages = [
    com.discordapp.Discord
    com.github.tchx84.Flatseal
    com.todoist.Todoist
  ];

}
