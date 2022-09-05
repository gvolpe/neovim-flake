{ ... }:

f: p:

let
  builder = p.callPackage ./metalsBuilder.nix { pkgs = p; };
in
{
  metals = builder {
    version = "0.11.8";
    outputHash = "sha256-j7je+ZBTIkRfOPpUWbwz4JR06KprMn8sZXONrtI/n8s=";
  };
}
