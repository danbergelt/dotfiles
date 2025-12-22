{ pkgs, lib, ... }:

let rustup = "${pkgs.rustup}/bin/rustup";

in {
  home.packages = [ pkgs.rustup ];

  home.activation.rustupComponents =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      is_component_installed() {
        ${rustup} component list --installed | grep -q "$1"
      }

      if ! is_component_installed rust-analyzer ; then
        ${rustup} component add rust-analyzer
      fi
    '';
}
