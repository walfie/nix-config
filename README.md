# nix-config

Nix configs for [home-manager].

## Install

* Install [Nix package manager](https://nixos.org/download.html):

    ```
    curl -L https://nixos.org/nix/install | bash -s -- --daemon --darwin-use-unencrypted-nix-store-volume

    # Recommended, but optional: disable spotlight indexing for the volume.
    sudo mdutil -i off /nix
    ```

  This assumes you're on at least macOS Catalina. Non-macOS setups can exclude
  the `darwin` flag and the `mdutil` command.

* Symlink to the desired machine config file in the [`machines/`](./machines/) directory:

    ```sh
    ln -s machines/$MACHINE_NAME current-machine
    ```

* Build the first home-manager generation

    ```sh
    nix-shell --run "home-manager switch -f current-machine"
    ```

  You can also use `home-manager build` instead of `home-manager switch` to
  verify the installation before applying it.

## Rebuild

After making changes to config, you can rebuild with:

```sh
home-manager switch
```

The `HOME_MANAGER_CONFIG` environment variable is typically set in the
`current-machine` config, so the `-f` argument used in the installation isn't
needed after the initial install.

## Updating dependencies

Dependencies are pinned and managed with `niv` (see `nix/sources.json`).

* To update `nixpkgs` to the latest revision on the current configured branch:

    ```sh
    niv update nixpkgs
    ```

* To update `nixpkgs` to the latest revision of a new branch (e.g., when
  switching to a new release branch):

    ```sh
    niv update nixpkgs -b release-21.05
    ```

* To get the updated packages to be picked up by `nix-direnv` in this
  directory, you may have to [manually re-trigger
  evaluation][direnv-evaluation]:

    ```sh
    touch shell.nix
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

