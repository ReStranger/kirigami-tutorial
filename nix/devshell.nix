_: {
  perSystem = {pkgs, ...}: {
    devShells.default = let
      inherit (pkgs) lib;
      kdePackages = with pkgs.kdePackages; [
        extra-cmake-modules
        kirigami
        ki18n
        kcoreaddons
        breeze
        kiconthemes
        sonnet
        qtbase
        qtdeclarative
        qqc2-desktop-style
      ];
      kdeDevPackages = map (pkg: pkg.dev or pkg) kdePackages;
      qmlPath = lib.makeSearchPath "lib/qt-6/qml" [
        pkgs.kdePackages.qtdeclarative
        pkgs.kdePackages.kirigami.passthru.unwrapped
        pkgs.kdePackages.qqc2-desktop-style
        pkgs.kdePackages.ki18n
        pkgs.kdePackages.kcoreaddons
        pkgs.kdePackages.kiconthemes

        # For kde style only
        pkgs.kdePackages.sonnet
      ];
      cmakePrefixPath = lib.makeSearchPath "lib/cmake" kdeDevPackages;
    in
      pkgs.mkShell {
        packages = with pkgs;
          [
            cmake
            clang-tools
            clang
            cmake-format
            ninja
            zsh
          ]
          ++ kdePackages;

        shellHook = ''
          export CMAKE_PREFIX_PATH="${cmakePrefixPath}''${CMAKE_PREFIX_PATH:+:$CMAKE_PREFIX_PATH}"
          export QML_IMPORT_PATH="${qmlPath}''${QML_IMPORT_PATH:+:$QML_IMPORT_PATH}"
          export QML2_IMPORT_PATH="${qmlPath}''${QML2_IMPORT_PATH:+:$QML2_IMPORT_PATH}"
          export QMLLS_BUILD_DIRS="$PWD/build"
          export SHELL=${lib.getExe pkgs.zsh}
          if [ -n "$PS1" ]; then
            exec ${lib.getExe pkgs.zsh}
          fi
        '';
      };
  };
}
