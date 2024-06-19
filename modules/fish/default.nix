{ pkgs, lib, ... }:
let
  color = code: text: "(set_color --bold ${code})${text}";
  space = "' '";
  prompt = builtins.concatStringsSep "" [
    "(date '+%H:%M:%S')"
    space
    (color "d78787" "(string replace $HOME '~' $PWD | path basename)")
    (color "d7d7af" "❯")
    "(set_color normal)"
    space
  ];

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
    };

    functions = {
      fish_greeting = "";
      fish_prompt = "string join '' -- ${prompt}";
      fish_right_prompt = ''
        set -l last_status $status
        set -q last_status_generation; or set -g last_status_generation $status_generation
        if test $last_status_generation != $status_generation
          if test $CMD_DURATION -gt 100
            echo -n (humantime $CMD_DURATION)
          end

          if test $last_status -ne 0
              echo -n (set_color red)" ✘ $last_status"
          end
        end
        set last_status_generation $status_generation
        set color normal
      '';
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
  };
}
