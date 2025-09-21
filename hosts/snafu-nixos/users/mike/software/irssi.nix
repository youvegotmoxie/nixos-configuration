{
  # Install and configure Irssi
  programs.irssi = {
    enable = false;
    networks = {
      liberachat = {
        nick = "moxie-_-";
        server = {
          address = "irc.libera.chat";
          port = 6697;
          autoConnect = true;
        };
      };
      iptorrents = {
        nick = "moxie-_-";
        server = {
          address = "irc.iptorrents.com";
          port = 6697;
          autoConnect = true;
        };
      };
    };
  };
}
