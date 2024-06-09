{ pkgs, lib, ... }:
let
  # Find and delete branches that were squash-merged
  git-delete-squashed =
    pkgs.writeShellScriptBin "git-delete-squashed" (lib.fileContents ./delete-squashed.sh);

  mkGitScript = script: "!f() { ${script} }; f";
in
{
  home.packages = [
    git-delete-squashed
  ];

  programs.git = {
    enable = true;

    aliases = {
      # Squash changes into the previous commit
      fixup = "!git add -u && git commit --fixup=HEAD && git rebase -i --autosquash HEAD~2";

      # Get default branch name (either `main` or `master`)
      default-branch = "!git branch --format='%(refname:short)' | grep -m1 -E '^main|master$'";

      # Get upstream name
      upstream = "!git remote show | grep -m1 -E '^upstream|origin|walfie$'";

      # Pull upstream/master branch
      up = mkGitScript ''
        local branch=$(git default-branch)
        git checkout $branch && git pull $(git upstream) $branch
      '';

      # git checkout (with fzf)
      cof = mkGitScript ''
        git branch --format='%(refname:short)' |
        ${pkgs.fzf}/bin/fzf |
        xargs git checkout
      '';
    };

    extraConfig = {
      core = { pager = "less -+F"; };
      pull = { rebase = false; };
      push = { default = "current"; };
      rebase = { autosquash = true; };
      rerere = { enabled = true; };
      init = { defaultBranch = "main"; };
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
      ".direnv"
      ".git"
      ".DS_Store"
      "Session.vim"
      "._/" # Personal directory to stash things I don't want to commit
    ];
  };
}
