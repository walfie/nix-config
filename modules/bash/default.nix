{ config, pkgs, lib, ... }:
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

  programs.autojump.enable = true;
  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" ];
    historySize = -1;
    historyFileSize = -1;
    historyFile = "${config.xdg.dataHome}/bash/history";
    shellOptions = [ "histappend" "checkwinsize" "extglob" ];
    sessionVariables = {
      PS1 = prompt;
      PROMPT_COMMAND = "history -a";
      HOMEBREW_NO_ANALYTICS = "1";
    };

    shellAliases = {
      ".." = "cd ..";
      grep = "grep --color -I";
      ips = "ifconfig | awk '\$1 == \"inet\" {print \$2}'";
      ll = "ls -l";
      ls = "ls -Gh";
      path = ''echo -e ''${PATH//:/\\n}'';
      z = "j";
    };
  };
}
