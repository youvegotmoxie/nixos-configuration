{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Add custom plugin for helix zsh bindings
  # https://github.com/Multirious/zsh-helix-mode
  zsh-helix-mode = pkgs.fetchFromGitHub {
    owner = "Multirious";
    repo = "zsh-helix-mode";
    rev = "2b4a40aa8956d345d8554f0c3ebbdc2fee619b9a";
    sha256 = "sha256-0/5B4SRHNo06ya0qNGy15yyOE6iZv7t4CLlO2Aody7g=";
  };
in
{
  sops.secrets.gh_token = {
    path = "${config.sops.defaultSymlinkPath}/gh_token";
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    history = {
      expireDuplicatesFirst = true;
      findNoDups = true;
      ignoreAllDups = true;
      size = 100000;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "git-extras"
      ];
    };
    shellAliases = {
      fps = "flatpak search";
      "lg" = "lazygit";
      "ls" = "eza";
      "rm" = "rm -v";
      "mv" = "mv -v";
      "cp" = "cp -v";
      "ln" = "ln -v";
      "mkdir" = "mkdir -v";
      "history" = "history -E";
      "sudo" = "nocorrect sudo";
      "tldr" = "nocorrect tldr";
      "gpm" = "git pull origin master";
      "ll" = "eza -lahg --git-repos-no-status --git";
      "grep" = "ugrep --color=auto";
      "cat" = "bat --paging=never --style=plain";
      "dive" = "docker run -it --rm  -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive";
      "sed" = "gsed";
    };
    initContent = lib.mkOrder 1500 ''
      export GH_TOKEN="$(cat ${config.sops.secrets.gh_token.path})"
      # Workaround for Atuin
      source "${zsh-helix-mode}/zsh-helix-mode.plugin.zsh"
      source "${config.home.homeDirectory}/.zsh.d/func.zsh"
      bindkey -M hxins '^r' atuin-up-search-vicmd
      bindkey -M hxnor '^r' atuin-up-search-vicmd
    '';
    sessionVariables = {
      TERM = "xterm-256color";
      SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
    };
  };
}
