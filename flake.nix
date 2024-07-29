{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
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
      self,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        inherit (pkgs) llvmPackages_18 cmake ninja;
        inherit (llvmPackages_18) stdenv clangUseLLVM;
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
        devShells.default = pkgs.mkShell.override { inherit stdenv; } {
          nativeBuildInputs = [
            clangUseLLVM
            cmake
            ninja
          ];
          shellHook = ''
            export PS1="\n\[\033[01;36m\]‹so-vits-svc› \\$ \[\033[00m\]"
          '';
        };

      }
    );
}
