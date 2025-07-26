{
  # Install and configure Halloy
  programs.halloy = {
    enable = true;
    settings = {
      "servers.liberachat" = {
        channels = [
          "#halloy"
        ];
        nickname = "moxie";
        server = "irc.libera.chat";
      };
    };
  };
}
