{ ... }:

f: p:

let
  builder = p.callPackage ./metalsBuilder.nix { pkgs = p; };
in
{
  metals = builder {
    version = "1.3.2";
    outputHash = "sha256-hRESY7TFxUjEkNf0vhCG30mIHZHXoAyZl3nTQ3OvQ0E=";
  };
}
