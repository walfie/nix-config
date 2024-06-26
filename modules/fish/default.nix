{ pkgs, lib, ... }:
let
  mkPlugin = name: { src, ... }: { inherit name src; };
  mkPlugins = lib.attrsets.mapAttrsToList mkPlugin;
in
{
  programs.fish = {
    enable = true;

    plugins = mkPlugins {
      nix-fish = pkgs.fishExtraPlugins.nix-fish;
      replay = pkgs.fishExtraPlugins.replay;
      humantime-fish = pkgs.fishPlugins.humantime-fish;
      transient-fish = pkgs.fishPlugins.transient-fish;
      fish-ssh-agent = pkgs.fishExtraPlugins.fish-ssh-agent;
    };

    shellAliases = {
      bat = "${pkgs.bat}/bin/bat -p";
      grep = "grep --color -I";
      ips = "${pkgs.inetutils}/bin/ifconfig | awk '\$1 == \"inet\" {print \$3}'";
      ll = "ls -l";
      ls = "${pkgs.coreutils}/bin/ls --color -h";
      man = "${pkgs.bat-extras.batman}/bin/batman";
      sed = "${pkgs.coreutils}/bin/sed";
    };

    interactiveShellInit = ''
      set -g color_primary d78787
      set -g color_secondary 87d7ff
      set -g color_accent d7d7af
      set -g color_dull 777777
    '';

    functions = {
      fish_greeting = "";

      fish_prompt = ''
        echo -n \n(set_color $color_dull)(dirs | string replace -r '[^/]+$' (set_color --bold $color_primary)'$0')(set_color normal)

        if test $transient_status -ne 0
            echo -n (set_color $color_dull)" • "(set_color red)"✘ $transient_status"
        end

        if test $CMD_DURATION -gt 100
            echo -n (set_color $color_dull)" • "(set_color $color_secondary)"⧖ "(humantime $CMD_DURATION)
        end

        echo \n(set_color $color_accent)"❯ "
      '';

      transient_prompt_func = ''
        echo -n (date '+%H:%M:%S') (set_color --bold $color_primary)(dirs | path basename)(set_color $color_accent)"❯ "(set_color normal)

        # If multi-line command, show the command on its own line
        test (commandline | wc -l) -gt 1 && echo \n
      '';

      transient_rprompt_func = ''
        set -q last_status_generation; or set -g last_status_generation $status_generation
        if test $last_status_generation != $status_generation
            if test $CMD_DURATION -gt 100
                echo -n "⧖ "(humantime $CMD_DURATION)
            end

            if test $transient_status -ne 0
                echo -n (set_color red)" ✘ $transient_status"
            end
        end
        set last_status_generation $status_generation
      '';
    };
  };
}
