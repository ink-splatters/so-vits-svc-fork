{
  clang_18,
  cmake,
  lib,
  lld_18,
  llvmPackages_18,
  mkShell,
  ninja,
  # pre-commit-check,
  stdenvNoCC,
  system,
  ...
}:
{

  default =
    let
      CFLAGS =
        "-O3  -ffast-math -funroll-loops"
        + lib.optionalString ("${system}" == "aarch64-darwin") " -mcpu=apple-m1";
      CXXFLAGS = "${CFLAGS}";
      LDFLAGS = "-flto -fuse-ld=lld";

      inherit (llvmPackages_18) stdenv;
    in
    mkShell.override { inherit stdenv; } {
      inherit CFLAGS CXXFLAGS LDFLAGS;
      hardeningDisable = [ "all" ];

      nativeBuildInputs = [
        clang_18
        lld_18
        llvmPackages_18.bintools
        cmake
        ninja
      ];

      # shellHook =
      #   pre-commit-check.shellHook
      #   + ''
      #     export PS1="\n\[\033[01;36m\]‹so-vits-svc› \\$ \[\033[00m\]"
      #     echo -e "\nto install pre-commit hooks:\n\x1b[1;37mnix develop .#install-hooks\x1b[00m"
      #   '';

      shellHook = ''
        export PS1="\n\[\033[01;36m\]‹so-vits-svc› \\$ \[\033[00m\]"
      '';
    };

  # install-hooks = mkShell.override { stdenv = stdenvNoCC; } {
  #   shellHook =
  #     let
  #       inherit (pre-commit-check) shellHook;
  #     in
  #     ''
  #       ${shellHook}
  #       echo Done!
  #       exit
  #     '';
  # };
}
