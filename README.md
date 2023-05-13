# nix-config

My personal Nix flake for [home-manager] on macOS.

[home-manager]: https://github.com/nix-community/home-manager

## Install

* Install [Nix package manager](https://nixos.org/download.html):

    ```sh
    curl -L https://nixos.org/nix/install | bash -s -- --daemon
    ```

  You can also replace the install URL with a specific version such as
  `https://releases.nixos.org/nix/nix-2.10.3/install` (this setup has been
  verified to work on at least `2.10.3`).

* If the per-user profile directory doesn't exist for your user at
  `/nix/var/nix/profiles/per-user/$(whoami)`, create it:

    ```sh
    sudo install -d --owner $(whoami) /nix/var/nix/profiles/per-user/$(whoami)
    ```

  (`install` is the same as `mkdir` followed by `chown`)

* `cd` into this repo's directory and run the following:

    ```sh
    nix flake --extra-experimental-features "nix-command flakes" lock --update-input vim-plugins-overlay
    ```

* Install home-manager and activate the [`personal` config] while in this directory:

    ```sh
    $(
      nix build \
      --extra-experimental-features "nix-command flakes" \
      --no-link \
      --print-out-paths \
      ".#homeConfigurations.personal.activationPackage"
    )/activate
    ```

  Note that the `personal` config targets `x86_64-darwin`, so you may need to
  update `flake.nix` if on a different platform (such as `aarch64-darwin`).

[`personal` config]: ./machines/personal/default.nix

## Rebuild

After making changes to config, you can rebuild with:

```sh
home-manager switch --flake ".#personal"
```

To apply changes without being in this directory, replace `.` with the path to
this directory.

Note the `--extra-experimental-features` flag isn't needed because our
home-manager config (via the [flakes module]) adds the relevant lines to
`~/.config/nix/nix.conf`.

[flakes module]: ./modules/flakes/default.nix

## Updating dependencies

Dependencies are defined in `flake.nix` and versions are pinned in `flake.lock`.

* To update all dependencies:

    ```sh
    nix flake update
    ```

* To update a specific depedency (such as `nixpkgs`):

    ```sh
    nix flake lock --update-input nixpkgs
    ```

## Errors

If you get the following error when trying to `switch`:

> cannot fetch input 'path:./overlays/vim-plugins?...' because it uses a relative path

It's likely because changes were made to `vim-plugins-overlay` without updating
the lock file. You may need to update it with the following command:

```sh
nix flake lock --update-input vim-plugins-overlay
```

## Garbage collection

There are various levels of cleanup you can do:

```sh
# Clean up files not used by any generations of the current profile
nix-collect-garbage

# Clean up files not used by the current generation of the current profile
nix-collect-garbage -d

# Clean up files not used by the current generation for any profile
sudo nix-collect-garbage -d
```

## Notes

In the past, it has been recommended to also run `sudo mdutil -i off /nix`
after installation to disable spotlight indexing, but recent versions of the
installer set the `nobrowse` option in the mount options, accomplishing the
same thing. See the [macOS installation] section of the documentation for
details.

[macOS installation]: https://github.com/NixOS/nix/blob/ddb82ffda993d237d62d59578f7808a9d98c77fe/doc/manual/src/installation/installing-binary.md#macos-installation

## Resources

Some resources I found useful during setup:

* [home-manager config options](https://nix-community.github.io/home-manager/options.html)
* [Vim on NixOS](https://web.archive.org/web/20200820230106/http://ivanbrennan.nyc/2018-05-09/vim-on-nixos)
* [Right way to add a custom package?](https://github.com/LnL7/nix-darwin/issues/16#issuecomment-284262711)
* [List of configurable macOS settings](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)
* [Nix Package Versions](https://lazamar.co.uk/nix-versions/)
* [Pkgs on Nix](https://pkgs.on-nix.com/)
* [Flakes - NixOS Wiki](https://nixos.wiki/wiki/Flakes)
* [cprussin/dotfiles](https://github.com/cprussin/dotfiles)
* [m15a/nixpkgs-vim-extra-plugins](https://github.com/m15a/nixpkgs-vim-extra-plugins)

