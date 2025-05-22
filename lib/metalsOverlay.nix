{ ... }:

f: p:

let
  builder = p.callPackage ./metalsBuilder.nix { pkgs = p; };
in
{
  metals = builder {
    version = "1.5.3";
    outputHash = "sha256-jxrAtlD+s3yjcDWYLoN7mr8RozutItCv8dt28/UoVjk=";
  };
}
