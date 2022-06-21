# This script assumes we have a git alias `default-branch`.
#
# Based on: https://github.com/not-an-aardvark/git-delete-squashed

default_branch=$(git default-branch)
git checkout -q $branch
git branch --format='%(refname:short)' | \
  while read branch;
  do
    mergeBase=$(git merge-base $default_branch $branch) \
      && [[ $(git cherry $default_branch $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]] \
      && git branch -D $branch;
  done

