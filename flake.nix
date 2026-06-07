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
      platforms = [
        {
          name = "wsl";
          system = "x86_64-linux";
          clipboard = "clip.exe";
        }
        {
          name = "linux-intel";
          system = "x86_64-linux";
          clipboard = "xclip -selection clipboard";
        }
        {
          name = "linux-arm";
          system = "aarch64-linux";
          clipboard = "xclip -selection clipboard";
        }
        {
          name = "mac-arm";
          system = "aarch64-darwin";
          clipboard = "pbcopy";
        }
        {
          name = "mac-intel";
          system = "x86_64-darwin";
          clipboard = "pbcopy";
        }
      ];
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
          cfg = builtins.head (builtins.filter (p: p.name == platform) platforms) // {
            inherit username homeDirectory;
          };
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${cfg.system};
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            helix-pkgs = nixpkgs-helix.legacyPackages.${cfg.system};
            inherit cfg;
          };
        };

      formatter =
        let
          systems = nixpkgs.lib.unique (map (p: p.system) platforms);
        in
        nixpkgs.lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
