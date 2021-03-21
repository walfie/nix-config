{ config, pkgs, lib, ... }:
let
  prompt =
    let
      color = code: text: "%F{${code}}${text}%f";
      bold = "%B";
      unbold = "%b";
      time = ''%*'';
      user = "%n";
      host = "%m";
      workingDir = "%1d";
    in
    builtins.concatStringsSep "" [
      time
      " "
      bold
      (color "187" "${user}@${host}:")
      (color "174" "${workingDir}$")
      unbold
      " "
    ];

  # Show exit code only if non-zero
  # https://stackoverflow.com/a/4466959/1887090
  rprompt = "%(?..%F{red}✘ %?%f)";
in
{
  programs.autojump.enable = true;
  programs.zsh = {
    enable = true;

    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      expireDuplicatesFirst = true;
      save = 9999999;
      size = 9999999;
    };

    defaultKeymap = "emacs";

    initExtra = ''
      # Enable Ctrl-x Ctrl-e to edit command line
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey '^x^e' edit-command-line
    '';

    sessionVariables = {
      PROMPT = prompt;
      RPROMPT = rprompt;
    };

    shellAliases = {
      grep = "grep --color -I";
      ips = "ifconfig | awk '\$1 == \"inet\" {print \$2}'";
      ll = "ls -l";
      ls = "ls -Gh";
      path = ''echo -e ''${PATH//:/\\n}'';
      z = "j";
    };
  };
}
