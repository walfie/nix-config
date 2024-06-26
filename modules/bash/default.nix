{ config, pkgs, ... }:
let
  # The `\[` and `\]` tell bash that the contents are non-printable
  # https://stackoverflow.com/questions/19092488/custom-bash-prompt-is-overwriting-itself
  prompt =
    let
      bold = ''\[$(tput bold)\]'';
      color1 = ''\[$(tput setaf 187)\]'';
      color2 = ''\[$(tput setaf 174)\]'';
      reset = ''\[$(tput sgr 0)\]'';
      time = ''\t'';
      user = ''\u'';
      host = ''\h'';
      workingDir = ''\W'';
    in
    "${time} ${bold}${color1}${user}@${host}:${color2}${workingDir}\$ ${reset}";
in
{
  home.packages = [
    pkgs.bash-completion
  ];

  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" ];
    historySize = -1;
    historyFileSize = -1;
    historyFile = "${config.xdg.dataHome}/bash/history";
    shellOptions = [ "histappend" "checkwinsize" "extglob" ];
    sessionVariables = {
      PROMPT_COMMAND = "history -a";
      PS1 = prompt;
    };

    initExtra = ''
      if [ -e $HOME/.nix-profile/etc/profile.d/bash_completion.sh ];
      then
        source $HOME/.nix-profile/etc/profile.d/bash_completion.sh
      fi

      if [ "''${BASH_VERSINFO:-0}" -ge 4 ];
      then
        HISTSIZE=-1
        HISTFILESIZE=-1
      else
        HISTSIZE=
        HISTFILESIZE=
      fi
    '';

    shellAliases = {
      ".." = "cd ..";
      grep = "grep --color -I";
      ips = "${pkgs.inetutils}/bin/ifconfig | awk '\$1 == \"inet\" {print \$3}'";
      ll = "ls -l";
      ls = "ls --color -h";
      path = ''echo -e ''${PATH//:/\\n}'';
    };
  };
}
