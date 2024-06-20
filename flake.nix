{  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forEachSystem = function:
        nixpkgs.lib.genAttrs supportedSystems (system: 
          function (let 
            pkgs = import nixpkgs { inherit system; };
          in { inherit pkgs; })
        );
    in {
      packages = forEachSystem ({ pkgs }: {
        default = pkgs.stdenv.mkDerivation {
          name = "build";
          src = self;
          nativeBuildInputs = with pkgs; [
            gnumake 
            yq
            jq 
            ejs 
            html-minifier
            sass
            (texlive.combine {
              inherit (texlive)
              scheme-small titlesec enumitem ulem yamlvars luapackageloader latexmk cm-unicode;
            })
            lua53Packages.lyaml
          ];
          shellHook = "export TEXMFHOME=.texlive-cache TEXMFVAR=.texlive-cache/texmf-var";
          buildPhase = "env TEXMFHOME=.texlive-cache TEXMFVAR=.texlive-cache/texmf-var make all";
          installPhase = "mkdir -p $out; cp dist/* $out";
        };
      });
    };
}
