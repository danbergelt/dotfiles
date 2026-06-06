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
    let
      configs = {
        wsl = {
          system = "x86_64-linux";
          clipboard = "clip.exe";
        };

        linux = {
          system = "x86_64-linux";
          clipboard = "xclip -selection clipboard";
        };

        mac = {
          system = "aarch64-darwin";
          clipboard = "pbcopy";
        };
      };
    in
    {
      formatter =
        let
          systems = nixpkgs.lib.unique (map (cfg: cfg.system) (builtins.attrValues configs));
        in
        nixpkgs.lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      homeConfigurations = builtins.mapAttrs (
        name: cfg:
        let
          pkgs = nixpkgs.legacyPackages.${cfg.system};
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./home.nix
          ];

          extraSpecialArgs = {
            helix-pkgs = nixpkgs-helix.legacyPackages.${cfg.system};

            inherit name;
            inherit (cfg) clipboard;
          };
        }
      ) configs;
    };
}
