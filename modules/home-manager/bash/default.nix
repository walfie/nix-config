{ config, pkgs, lib, ... }:
let
  prompt = let
    bold = "$(tput bold)";
    color1 = "$(tput setaf 187)";
    color2 = "$(tput setaf 174)";
    reset = "$(tput sgr 0)";
    time = ''\t'';
    user = ''\u'';
    host = ''\h'';
    workingDir = ''\W'';
  in
    "${time} ${bold}${color1}${user}@${host}:${color2}${workingDir}\$ ${reset}";
in
{
  programs.bash.enableCompletion = true;

  environment.shells = [ pkgs.bashInteractive_5 ];

  primary-user.shell = pkgs.bashInteractive_5;

  primary-user.home-manager.home.packages = [
    pkgs.bash-completion
    pkgs.bashInteractive_5
  ];

  primary-user.home-manager.programs.bash = {
    enable = true;
    enableAutojump = true;
    historyControl = [ "ignoredups" ];
    historySize = -1;
    historyFileSize = -1;
    historyFile = "${config.primary-user.home-manager.xdg.dataHome}/bash/history";
    sessionVariables = {
      PS1 = prompt;
      PROMPT_COMMAND = "history -a";
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
