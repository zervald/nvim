{
  description = "Richard nvim flake using nixCats";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      nvim = import ./. { inherit inputs; };
    in
    {
      packages = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ ];
            config = { };
          };
        in
        nvim.packages.${system}
      );
      homeModules.default = nvim.homeModule; # <- it will get the system from the importing configuration
      nixosModules.default = nvim.nixosModule; # <- module namespace defaults to defaultPackageName.{ enable, packageNames, etc... }
    };
}
