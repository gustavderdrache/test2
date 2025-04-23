{
  description = "My Nix project";

  inputs = {
    nixpkgs.url = "https://api.flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
  };



  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [ hello git openssl ];
        a = 9999999;
      };
    };
}
