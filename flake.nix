{
  description = "Hetzner Cloud Pulumi Provider";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkPulumiPackage = pkgs.callPackage "${nixpkgs}/pkgs/tools/admin/pulumi-packages/base.nix" {};
    in rec {
      packages = rec {
        default = pulumi-hcloud;
        pulumi-hcloud = mkPulumiPackage rec {
          owner = "pulumi";
          repo = "pulumi-hcloud";
          version = "1.16.2";
          rev = "v${version}";
          hash = "sha256-gIRsigpLCzl9RNOV/j6n19YrHsSdQvr5cb6Z2+qzv8c=";
          vendorHash = "sha256-qZc1U3EBCWwhLzFyZjiNu8g447b/IQp0Mx5/FdFo2dQ=";
          cmdGen = "pulumi-tfgen-hcloud";
          cmdRes = "pulumi-resource-hcloud";
          extraLdflags = [
            "-X github.com/pulumi/${repo}/provider/pkg/version.Version=v${version}"
          ];

          fetchSubmodules = false;
          meta = with pkgs; with lib; {
            description = "Hetzner Cloud Pulumi Provider";
            homepage = "https://github.com/pulumi/pulumi-hcloud";
            license = licenses.asl20;
            maintainers = with maintainers; [ ];
          };
        };
      };
    }
  );
}
