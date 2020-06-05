{ config, options, ... }:

let
  # This config file is meant to be used via a symlink, so the paths are
  # relative to the `current-machine` symlink.
  sources = import ../nix/sources.nix;
  overlay = self: super: {
    niv = (import sources.niv {}).niv;
  };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay ];
  };

in
{
  imports = [
    "${sources.home-manager}/nix-darwin"
  ];

  # Path to this file. To change this value, run:
  # $ darwin-rebuild switch -I darwin-config=$HOME/path/to/this/file.nix
  environment = {
    darwinConfig = "$HOME/nix-config/current-machine/default.nix";
    shells = [ pkgs.bashInteractive_5 ];

    interactiveShellInit = ''
      # This is needed, otherwise some env vars aren't set in tmux
      # https://github.com/LnL7/nix-darwin/pull/174
      unset __NIX_DARWIN_SET_ENVIRONMENT_DONE
    '';
  };

  nix = {
    # You should generally set this to the total number of logical cores in your system.
    # $ sysctl -n hw.ncpu
    maxJobs = 12;
    buildCores = 12;

    nixPath = [
      { darwin = "${sources.nix-darwin}"; }
      { nixpkgs = "${sources.nixpkgs}"; }
    ];

  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system.defaults = {
    NSGlobalDomain = {
      AppleFontSmoothing = 2;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    dock.tilesize = 32;
    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
    };
    screencapture.location = "$HOME/Pictures/screenshots/";
  };

  services.nix-daemon.enable = true;

  networking.hostName = "luminas";

  fonts = {
    enableFontDir = true;
    fonts = [ pkgs.inconsolata ];
  };

  users.users.who.shell = pkgs.bashInteractive_5;

  home-manager.users.who = { lib, pkgs, ... }: {
    home.packages = [
      pkgs.bash-completion
      pkgs.bashInteractive_5
      pkgs.doctl
      pkgs.gnused
      pkgs.htop
      pkgs.kubectl
      pkgs.kubectx
      pkgs.ncdu
      pkgs.neovim
      pkgs.niv
      pkgs.ripgrep
      pkgs.tealdeer
      pkgs.tmux
      pkgs.wget
    ];

    programs.tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      keyMode = "vi";
      shortcut = "a";
      plugins = with pkgs; [
        tmuxPlugins.pain-control
        tmuxPlugins.sensible
        tmuxPlugins.yank
      ];

      extraConfig = ''
        set-option -ga update-environment ' NIX_PATH'
        set -g renumber-windows on

        # Window number, program name, active (or not)
        set -g set-titles-string '#H:#S.#I.#P #W #T'

        # Highlight active window
        setw -g window-status-current-style bg=white

        # Lowers delay time between prefix key and other keys
        set -sg escape-time 0

        # Ctrl-a twice to send Ctrl-a to the application
        bind a send-prefix
        bind C-a send-prefix

        # Zenburn color scheme
        setw -g clock-mode-colour colour117
        setw -g mode-style fg=colour117,bg=colour238,bold
        set -g status-style fg=colour248,bg=colour235
        setw -g window-status-current-style fg=colour223,bg=colour237,bold
        set -g message-style fg=colour117,bg=colour235,bold
        set -g pane-active-border-style fg=colour245
        set -g pane-border-style fg=colour235
      '';
    };

    programs.git = {
      userName = "Walfie";
      userEmail = "walfington@gmail.com";

      aliases = {
        up = "!f() { local branch=\${1:-master}; git checkout $branch && git pull \${3:-upstream} $branch; }; f";
        fixup = "!git add -A && git commit --fixup=HEAD && git rebase -i --autosquash HEAD~2";
      };

      extraConfig = {
        core = { pager = "less -+F"; };
        push = { default = "current"; };
        rebase = { autosquash = true; };
        rerere = { enabled = true; };
        color = {
          branch = "auto";
          diff = "auto";
          interactive = "auto";
          status = "auto";
        };
      };

      enable = true;
      ignores = [
        "*.swp"
        "*.swo"
        ".DS_Store"
        "Session.vim"
      ];
    };

    programs.bash = {
      enable = true;
      enableAutojump = true;
      historyControl = [ "ignoredups" ];
      historySize = -1;
      historyFileSize = -1;
      initExtra = ''
        PROMPT_COMMAND="history -a";
        RLWRAP_HOME="$HOME/.local/share/rlwrap/";
        EDITOR="nvim";

        LS_COLORS="di=38;5;108:fi=00:ln=38;5;116:ex=38;5;186";
        COLOR1="\[$(tput setaf 187)\]";
        COLOR2="\[$(tput setaf 174)\]";
        RESET="\[$(tput sgr 0)\]";
        BOLD="\[$(tput bold)\]";
        PS1="\t $BOLD$COLOR1\u@\h:$COLOR2\W\\$ $RESET";
      '';

      shellAliases = {
        ".." = "cd ..";
        grep = "grep --color -I";
        ips = "ifconfig | awk '\$1 == \"inet\" {print \$2}'";
        ll = "ls -l";
        ls = "ls -G";
        path = "echo -e $${PATH//:/\\n}";
        z = "j";
      };

      sessionVariables = {};
    };
  };

}
