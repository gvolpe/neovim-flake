{ ... }:

f: p:

let
  builder = p.callPackage ./metalsBuilder.nix { pkgs = p; };
in
{
  metals = builder {
    version = "0.11.9";
    outputHash = "sha256-CJ34OZOAM0Le9U0KSe0nKINnxA3iUgqUMtS06YnjvVo=";
  };
}
