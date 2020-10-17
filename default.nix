{ pkgs ? import <nixpkgs> { }, }:
let
  date = "2020/10/16";
  versionNumber = "0.3.7";

  inherit (pkgs) stdenv lib fetchzip texlive sd;

  charter = stdenv.mkDerivation rec {
    pname = "charter";
    version = "200512";

    src = fetchzip {
      url = "https://practicaltypography.com/fonts/Charter%20${version}.zip";
      name = "Charter-${version}.zip";
      sha256 = "1832amplwrxp3cwyf2xnc47f5fasbwhdc2i4sblbhgdgga07pxa0";
    };

    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/fonts/opentype/public
      mv "Charter/OpenType" $out/fonts/opentype/public/charter
      mv "Charter license.txt" $out/fonts/opentype/public/charter/LICENSE.txt
      # mv "Charter/OpenType TT" $out/share/fonts/truetype
      # mv "Charter/WOFF" $out/share/fonts/woff
    '';

    # needed for texlive...
    tlType = "run";
  };

  charter-texlive = { pkgs = lib.singleton charter; };

  pkg = "rebeccaessay";
  versionSentinel = "\${VERSION}$";
  dateSentinel = "\${DATE}$";
  build = { pdf ? true, tar ? true, ... }:
    stdenv.mkDerivation rec {
      inherit pkg versionNumber date;
      name = "latex-${pkg}";
      pname = "latex-${pkg}-${versionNumber}";
      version = "${date} ${versionNumber}";

      buildInputs = [
        (texlive.combine rec {
          inherit (texlive)
            scheme-small collection-xetex latexmk collection-latexrecommended
            ltxguidex translations framed enumitem showexpl babel babel-german
            babel-english changepage fira varwidth changelog titlesec;
          charter = charter-texlive;
        })
        sd
      ];

      src = ./.;
      distSrcs = [
        "rebeccaessay.cls"
        "rebeccastyle.sty"
        "LICENSE.txt"
        "README.md"
        "default.nix"
        "*.pdf"
      ];

      dontConfigure = true;
      buildPhase = let latexmk = "latexmk -pdf -r ./latexmkrc -pvc- -pv-";
      in ''
        sd --string-mode \
           ${lib.escapeShellArg versionSentinel} ${lib.escapeShellArg version} \
           *.tex *.sty *.cls
        sd --string-mode \
           ${lib.escapeShellArg dateSentinel} ${lib.escapeShellArg date} \
           *.tex *.sty *.cls

        ${lib.optionalString pdf "${latexmk} *.tex"}

        rm -rf ${pkg}
        mkdir ${pkg}
        cp $distSrcs ${pkg}
      '';

      installPhase = ''
        ${if tar then ''
          tar -czf ${pkg}.tar.gz ${pkg}
          tar -tvf ${pkg}.tar.gz
          cp ${pkg}.tar.gz $out
        '' else ''
          mkdir -p $out
          cp -r ${pkg} $out
        ''}
      '';
    };

  tar = build { };
  dir = build {
    pdf = false;
    tar = false;
  };
  dir-pdf = build { tar = false; };

  # Copied from nixpkgs.
  combinePkgs = pkgSet:
    lib.concatLists # uniqueness is handled in `texlive.combine`
    (lib.mapAttrsToList (_n: a: a.pkgs) pkgSet);
in {
  inherit tar dir dir-pdf;
  texlive = {
    pkgs = lib.singleton (dir.overrideAttrs (old: {
      tlType = "run";
      installPhase = old.installPhase + ''
        mkdir -p $out/tex/latex/
        mv $out/${old.pkg} $out/tex/latex/
      '';
    }));
  };
}
