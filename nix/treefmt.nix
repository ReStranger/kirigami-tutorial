{inputs, ...}: {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = _: {
    treefmt.config = {
      projectRootFile = "flake.nix";
      settings = {
        global.excludes = [
          "LICENSE"
          ".gitattributes"

          "*.png"
          "*.svg"
          "build/**"
          ".cache/**"
          ".direnv/**"
        ];
      };

      programs = {
        deadnix.enable = true;
        alejandra.enable = true;
        statix.enable = true;
        clang-format.enable = true;
        clang-tidy = {
          enable = true;
          compileCommandsPath = "build";
        };
        cmake-format.enable = true;
      };
    };
  };
}
