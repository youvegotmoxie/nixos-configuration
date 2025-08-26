{config, ...}: {
  # Install and configure Halloy
  # Using the Flatpak for now since it's newer
  programs.halloy = {
    enable = true;
    settings = {
      buffer.channel.topic = {
        enabled = true;
      };
      actions.buffer = {
        click_channel_name = "replace-pane";
        click_username = "replace-pane";
      };
      actions.sidebar = {
        buffer = "replace-pane";
      };
      buffer.channel.nicklist = {
        enabled = false;
      };
      buffer.server_messages.join = {
        enabled = false;
      };
      buffer.server_messages.part = {
        enabled = false;
      };
      buffer.server_messages.quit = {
        enabled = false;
      };

      servers.liberachat = {
        nickname = "youvegotmoxie";
        server = "irc.libera.chat";
        nick_password_file = "${config.home.homeDirectory}/halloy_libera_youvegotmoxie";
        channels = ["#nixos" "#python" "#linux" "##politics" "#networking" "##programming" "#hardware" "##chat" "#docker" "#helix" "#kubernetes"];
      };
      servers.iptorrents = {
        nickname = "moxie";
        server = "irc.iptorrents.com";
        channels = ["#iptorrents"];
      };
    };
  };
}
