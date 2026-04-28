{ config, pkgs, ... }:

let
  cfg = config.vim.lsp;

  artifacts = pkgs.stdenv.mkDerivation {
    name = "smithy-artifacts";

    nativeBuildInputs = [ cfg.smithy.launcher pkgs.jdk ];

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-ueF3tFMJLj4iBHbkyuYFV6pXRHeBHGI7QN2OxMQz1OQ=";

    buildCommand = ''
      export COURSIER_CACHE=$(pwd)/.cache
      mkdir -p $out
      for jar in $(${cfg.smithy.launcher}/bin/cs fetch ${cfg.smithy.server.name}:${cfg.smithy.server.version}); do
        cp "$jar" $out/
      done
    '';
  };
in
pkgs.stdenv.mkDerivation {
  name = "smithy-ls";
  nativeBuildInputs = [ pkgs.makeWrapper ];
  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${pkgs.jdk}/bin/java $out/bin/smithy-ls \
      --add-flags "-Xmx2G" \
      --add-flags "-cp '${artifacts}/*'" \
      --add-flags "${cfg.smithy.server.class}" \
      --add-flags "0"

    sed -i 's|exec |exec 2>/tmp/smithy-ls.log |' $out/bin/smithy-ls
  '';
}
