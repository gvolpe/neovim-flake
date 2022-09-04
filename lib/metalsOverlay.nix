{ ... }:

f: p:

let
  builder = p.callPackage ./metalsBuilder.nix { pkgs = p; };
in
{
  metals = builder {
    version = "0.11.8+76-22425a8b-SNAPSHOT";
    outputHash = "sha256-8z93Io9eBvLZxSIEARQNJ21szIDxIJrd0P8aCQPEqUg=";
  };
}
