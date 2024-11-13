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

        inherit (pkgs)
          cmake
          ninja
          lib
          llvmPackages_19
          lld_19
          ;
        inherit (lib) optionalString;
        inherit (llvmPackages_19) stdenv clangUseLLVM;

        # CFLAGS = "-O3  -ffast-math -funroll-loops " + lib.optionalString stdenv.isDarwin "-mcpu=apple-m1";
        # CXXFLAGS = "${CFLAGS}";
        CFLAGS = "";
        CXXFLAGS = "";
        LDFLAGS = "-fuse-ld=lld"; # -flto
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
        devShells.default = pkgs.mkShell.override { inherit stdenv; } {
          inherit CFLAGS CXXFLAGS LDFLAGS;
          nativeBuildInputs = [
            clangUseLLVM
            lld_19
            ninja
            cmake
          ];
          shellHook = ''
            export PS1="\n\[\033[01;36m\]‹so-vits-svc› \\$ \[\033[00m\]"
          '';
        };

      }
    );
}
