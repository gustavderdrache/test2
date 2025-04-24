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
      packages.${system} = {
        badHash = derivation {
          name = "badHash";
          inherit system;

          PATH = "${pkgs.coreutils}/bin";

          builder = "/bin/sh";
          args = [
            "-c"
            ''
            sleep 1
            echo bad >$out
            ''
          ];

          outputHashMode = "flat";
          outputHashAlgo = "sha256";
          outputHash = pkgs.lib.fakeSha256;
        };

        fail = derivation {
          name = "fail";
          inherit system;

          PATH = "${pkgs.coreutils}/bin";

          builder = "/bin/sh";
          args = [
            "-ec"
            ''
            sleep 1
            echo "failing, bye"
            exit 1
            ''
          ];
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [ hello git openssl ];
        a = 3;
      };
    };
}
