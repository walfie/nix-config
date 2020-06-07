{ config, pkgs, lib, ... }:
let
  # Find and delete branches that were squash-merged
  git-delete-squashed =
    pkgs.writeShellScriptBin "git-delete-squashed" (lib.fileContents ./delete-squashed.sh);

  # git checkout (with fzf)
  git-cof =
    pkgs.writeShellScriptBin "git-cof" ''
      export PATH=${pkgs.stdenv.lib.makeBinPath [ pkgs.git pkgs.fzf ]}:$PATH
      git checkout "$(git branch --all | fzf | tr -d '[:space:]')"
    '';
in
{
  primary-user.home-manager.home.packages = [
    git-delete-squashed
    git-cof
  ];

  primary-user.home-manager.programs.git = {
    enable = true;

    aliases = {
      # Pull upstream/master branch
      up = "!f() { local branch=\${1:-master}; git checkout $branch && git pull \${3:-upstream} $branch; }; f";

      # Squash changes into the previous commit
      fixup = "!git add -u && git commit --fixup=HEAD && git rebase -i --autosquash HEAD~2";
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

    ignores = [
      "*.swp"
      "*.swo"
      ".DS_Store"
      "Session.vim"
    ];
  };
}
