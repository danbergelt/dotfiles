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
      platforms = {
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
      inherit platforms;

      mkHome =
        {
          platform,
          username,
          homeDirectory,
        }:
        let
          cfg = platforms.${platform};
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${cfg.system};
          modules = [
            ./home.nix
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
          ];
          extraSpecialArgs = {
            helix-pkgs = nixpkgs-helix.legacyPackages.${cfg.system};
            inherit (cfg) clipboard;
          };
        };

      formatter =
        let
          systems = nixpkgs.lib.unique (map (cfg: cfg.system) (builtins.attrValues platforms));
        in
        nixpkgs.lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
