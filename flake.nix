{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";

    # gitignore = {
    #   url = "github:hercules-ci/gitignore.nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    # git-hooks = {
    #   url = "github:cachix/git-hooks.nix";
    #   inputs = {
    #     gitignore.follows = "gitignore";
    #     nixpkgs.follows = "nixpkgs";
    #     nixpkgs-stable.follows = "nixpkgs";
    #   };
    # };
  };

  nixConfig = {
    extra-substituters = [ "https://aarch64-darwin.cachix.org" ];
    extra-trusted-public-keys = [
      "aarch64-darwin.cachix.org-1:mEz8A1jcJveehs/ZbZUEjXZ65Aukk9bg2kmb0zL9XDA="
    ];
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      # git-hooks,
      self,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        inherit (pkgs) callPackage;
      in
      {

        # checks.pre-commit-check = callPackage ./nix/pre-commit-check.nix { inherit git-hooks system; };

        formatter = pkgs.nixfmt-rfc-style;

        devShells = callPackage ./nix/shells.nix {
          inherit (self.checks.${system});
          # pre-commit-check;
        };
      }
    );
}
