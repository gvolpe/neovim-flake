{ ... }:

f: p:

let
  builder = p.callPackage ./metalsBuilder.nix { pkgs = p; };
in
{
  metals = builder {
    version = "0.11.10";
    outputHash = "sha256-CNLBDsyiEOmMGA9r8eU+3z75VYps21kHnLpB1LYC7W4=";
  };
}
