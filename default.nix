{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs {}
, inShell ? null
}:

let

  deps = with pkgs; [
    pandoc
    pandoc-include
    haskellPackages.pandoc-crossref
    typst
    shake
  ];

  env = pkgs.mkShell {
    buildInputs = deps ++ [
    ];
  };

  # TODO
  drv = pkgs.mkShell {
  };

in if inShell == false
   then drv
   else if pkgs.lib.inNixShell then env else drv
