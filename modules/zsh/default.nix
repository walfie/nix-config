{ config, pkgs, ... }:
let
  prompt =
    let
      color = code: text: "%F{${code}}${text}%f";
      bold = "%B";
      unbold = "%b";
      time = ''%*'';
      workingDir = "%1~";
    in
    builtins.concatStringsSep "" [
      time
      " "
      bold
      (color "174" "${workingDir}$")
      unbold
      " "
    ];

  # Show exit code only if non-zero
  # https://stackoverflow.com/a/4466959/1887090
  rprompt = "%(?..%F{red}✘ %?%f)";
in
{
  programs.zoxide.enable = true;

  programs.zsh = {
    enable = true;

    # Enable autocomplete manually by calling `compinit` ourselves
    # (to prevent `.zcompdump` from being created in the home directory)
    # https://unix.stackexchange.com/questions/391641/separate-path-for-zcompdump-files
    # https://github.com/nix-community/home-manager/blob/ddcd476603dfd3388b1dc8234fa9d550156a51f5/modules/programs/zsh.nix#L458
    enableCompletion = false;
    initExtraBeforeCompInit = ''
      autoload -U compinit && compinit -d ${config.xdg.cacheHome}/zcompdump-$ZSH_VERSION
    '';

    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      expireDuplicatesFirst = true;
      save = 999999999;
      size = 999999999;
      share = false;
      extended = true;
    };

    defaultKeymap = "emacs";

    initExtra = ''
      # Enable Ctrl-x Ctrl-e to edit command line
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey '^x^e' edit-command-line

      # Allow selecting completion items with arrow keys
      zstyle ':completion:*' menu select

      # Append history immediately (but don't share between shells)
      setopt INC_APPEND_HISTORY

      # Don't return duplicates when searching history
      setopt HIST_FIND_NO_DUPS
    '';

    localVariables = {
      PROMPT = prompt;
      RPROMPT = rprompt;
    };

    shellAliases = {
      bat = "${pkgs.bat}/bin/bat -p";
      grep = "grep --color -I";
      ips = "${pkgs.inetutils}/bin/ifconfig | awk '\$1 == \"inet\" {print \$3}'";
      ll = "ls -l";
      ls = "${pkgs.coreutils}/bin/ls --color -h";
      path = ''echo -e ''${PATH//:/\\n}'';
    };
  };
}
