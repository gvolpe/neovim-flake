{ ... }:

f: p:

let
  builder = p.callPackage ./metalsBuilder.nix { pkgs = p; };
in
{
  metals = builder {
    version = "1.5.2";
    outputHash = "sha256-Qh8T0/nLVpfdJiWqdi1mpvUom5B9Xr8jsNGqzEx8OLs=";
  };
}
