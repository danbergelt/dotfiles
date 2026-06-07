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

  outputs =
    {
      nixpkgs,
      nixpkgs-helix,
      home-manager,
      ...
    }:
    {
      mkHome =
        {
          system,
          isWsl ? false,
          username,
          homeDirectory,
        }:
        let
          cfg = {
            inherit
              system
              isWsl
              username
              homeDirectory
              ;
          };
        in
        {
          homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [ ./home.nix ];
            extraSpecialArgs = {
              helix-pkgs = nixpkgs-helix.legacyPackages.${system};
              inherit cfg;
            };
          };
        };
    };
}
