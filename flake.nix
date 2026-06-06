{
  description = "Home environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Pinned: helix 25.01
    nixpkgs-helix.url = "github:NixOS/nixpkgs/de0fe301211c267807afd11b12613f5511ff7433";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-helix, home-manager, ... }:
    let
      pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
      isWSL = builtins.getEnv "WSL_DISTRO_NAME" != "";
    in {
      homeConfigurations.home = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          helix-pkgs = nixpkgs-helix.legacyPackages.${builtins.currentSystem};
          clipboard = if isWSL then
            "clip.exe"
          else if pkgs.stdenv.isDarwin then
            "pbcopy"
          else if pkgs.stdenv.isLinux then
            "xclip -selection clipboard"
          else
            abort "Unknown clipboard";
        };
      };
    };
}
