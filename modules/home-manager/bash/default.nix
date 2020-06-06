{ config, pkgs, lib, ... }:
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
  };
}
