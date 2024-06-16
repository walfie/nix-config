{ pkgs, ... }:
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

  nix-fish = {
    name = "nix.fish";
    src = pkgs.fetchFromGitHub {
      owner = "kidonng";
      repo = "nix.fish";
      rev = "ad57d970841ae4a24521b5b1a68121cf385ba71e";
      sha256 = "sha256-GMV0GyORJ8Tt2S9wTCo2lkkLtetYv0rc19aA5KJbo48=";
    };
  };
in
{
  programs.fish = {
    enable = true;

    plugins = [ nix-fish ];

    functions = {
      fish_greeting = "";
      fish_prompt = "string join '' -- ${prompt}";
      fish_right_prompt = ''
        set -l cmd_status $status
        if test $cmd_status -ne 0
            echo -n (set_color red)"✘ $cmd_status"
        end
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
