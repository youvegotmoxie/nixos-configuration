{config, ...}: {
  # Configure Git for the user
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showNumstatInFilesView = true;
        nerdFontsVersion = "3";
      };
      git.paging = {
        pager = "delta --dark --paging=never --max-line-length=0";
        useConfig = false;
      };
    };
  };
  programs.git = {
    enable = true;
    userName = "MikeB";
    userEmail = "youvegotmoxie@gmail.com";
    signing.key = "${config.home.homeDirectory}/.ssh/git-signing_ed25519.pub";
    extraConfig = {
      core = {
        pager = "delta --pager=never --max-line-length=0";
        editor = "hx";
      };
      gpg.format = "ssh";
      commit.gpgsign = true;
      init = {
        defaultBranch = "master";
      };
      pull = {
        rebase = false;
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      delta = {
        navigate = false;
        light = false;
        hyperlinks = true;
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
      push = {
        autoSetupRemove = true;
      };
      filter = {
        lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
    };
  };
}
