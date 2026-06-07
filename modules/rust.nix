{ pkgs, lib, ... }:

let
  rustup = "${pkgs.rustup}/bin/rustup";
  toolchain = "stable";
  components = [ "rust-analyzer" ];

in
{
  home.packages = [ pkgs.rustup ];

  home.activation.rustupComponents = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${rustup} default &> /dev/null; then
      ${rustup} default ${toolchain}
    fi

    for component in ${lib.concatStringsSep " " components}; do
      if ! ${rustup} component list --installed | grep -q "$component"; then
        ${rustup} component add "$component"
      fi
    done
  '';
}
