# nix-config

Nix configs for [home-manager] on macOS.

## Install

* Install [Nix package manager](https://nixos.org/download.html):

    ```sh
    curl -L https://nixos.org/nix/install | bash -s -- --daemon
    ```

* Enable nix flakes by adding the following to `~/.config/nix/nix.conf`:

    ```
    experimental-features = nix-command flakes
    ```

* Install home-manager (while in this directory):

    ```sh
    CONFIG_NAME=luminas
    $(
      nix build \
      --extra-experimental-features "nix-command flakes" \
      --no-link \
      --print-out-paths \
      ".#homeConfigurations.$CONFIG_NAME.activationPackage"
    )/activate
    ```

## Rebuild

After making changes to config, you can rebuild with:

```sh
home-manager switch --flake ".#luminas"
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

* [home-manager config options](https://rycee.gitlab.io/home-manager/options.html)
* [cprussin/dotfiles](https://github.com/cprussin/dotfiles)
* [Vim on NixOS](https://web.archive.org/web/20200820230106/http://ivanbrennan.nyc/2018-05-09/vim-on-nixos)
* [Right way to add a custom package?](https://github.com/LnL7/nix-darwin/issues/16#issuecomment-284262711)
* [List of configurable macOS settings](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)
* [Nix Package Versions](https://lazamar.co.uk/nix-versions/)

[home-manager]: https://github.com/nix-community/home-manager
[direnv-evaluation]: https://github.com/nix-community/nix-direnv/tree/40b96cbd3589fd7f06e8da9324b98aa9c2b6b594#manually-re-triggering-evaluation

