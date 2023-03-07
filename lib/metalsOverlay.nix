{ ... }:

f: p:

let
  builder = p.callPackage ./metalsBuilder.nix { pkgs = p; };
in
{
  metals = builder {
    version = "0.11.11";
    outputHash = "sha256-oz4lrRnpVzc9kN+iJv+mtV/S1wdMKwJBkKpvmWCSwE0=";
  };
}
