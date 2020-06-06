# nix-config

Nix configs with [nix-darwin] and [home-manager].

## Install

* Install [Nix package manager](https://nixos.org/download.html):

    ```sh
    sh $(curl -L https://nixos.org/nix/install) --daemon --darwin-use-unencrypted-nix-store-volume
    ```

  If on macOS Catalina on a machine without a T2 chip, you may need to create
  the Nix APFS volume manually.  See "Solution 1" in [this GitHub comment by
  garyverhaegen-da](https://github.com/NixOS/nix/issues/2925).

* Symlink to the desired machine config file in the [`machines/`](./machines/) directory:

    ```sh
    ln -s machines/$MACHINE_NAME current-machine
    ```

* If on macOS, run the provided script to install nix-darwin:

    ```sh
    nix-shell --run install-darwin
    ```

  You can say no when it asks if you want to manage nix-darwin with channels.
  The config in this repo pins nix-darwin and nixpkgs with
  [niv](https://github.com/nmattia/niv/), and doesn't use channels.

  Even though we don't use channels, you may need to remove the
  `~/.nix-defexpr/channels` symlink and recreate it with `nix-channel --update`,
  since the Nix installer creates that symlink owned by the root user, but
  nix-darwin expects it to be owned by the current user.

  The nix-darwin installer will warn you if there are existing files that it
  would have overwritten (`/etc/nix/nix.conf`, `~/.bashrc`, etc). Feel free to
  move them or delete them.

## Rebuild

After making changes to config, you can rebuild with:

```sh
rebuild-darwin switch
```

## Formatting

The following command will run `nixpkgs-fmt` on all `.nix` files in this repo:

```sh
nix-shell --run format
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
* [nix-darwin config options](https://lnl7.github.io/nix-darwin/manual/index.html#sec-options)
* [cprussin/dotfiles](https://github.com/cprussin/dotfiles)
* [Vim on NixOS](http://ivanbrennan.nyc/2018-05-09/vim-on-nixos)
* [Right way to add a custom package?](https://github.com/LnL7/nix-darwin/issues/16#issuecomment-284262711)
* [List of configurable macOS settings](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)

[nix-darwin]: https://github.com/LnL7/nix-darwin
[home-manager]: https://github.com/rycee/home-manager

