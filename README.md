# neovim-flake

Nix flake for [neovim](https://neovim.io/) with configuration options

![screenshot](./docs/screenshot.png)

## Try it out

```console
$ cachix use gvolpe-nixos # Optional: it'll save you CPU resources and time
$ nix run github:gvolpe/neovim-flake
```

By default, LSP support is enabled for Scala, Dhall, Elm, Nix, Haskell, and Smithy.

More details here: [https://gvolpe.com/neovim-flake](https://gvolpe.com/neovim-flake).

## Credits

Originally based on Jordan Isaacs' [neovim-flake](https://github.com/jordanisaacs/neovim-flake).
