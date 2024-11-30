{ ... }:

f: p:

let
  builder = p.callPackage ./metalsBuilder.nix { pkgs = p; };
in
{
  metals = builder {
    version = "1.4.1";
    outputHash = "sha256-CVAPjeTYuv0w57EK/IldJcGz8mTQnyCGAjaUf6La2rU=";
  };
}
