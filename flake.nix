{
  description = "Declarative NixOS configuration for the homelab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/homelab
          sops-nix.nixosModules.sops
        ];
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          age
          sops
        ];
      };
    };
}