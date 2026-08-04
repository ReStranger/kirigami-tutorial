{
  description = "Kirigami tutorial flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs @ {flake-parts, ...}: let
    nixModules =
      builtins.filter
      (f: builtins.match ".*\.nix" f != null)
      (builtins.attrNames (builtins.readDir ./nix));
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = map (f: ./nix/${f}) nixModules;
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
    };
}
