final: prev:
let
  rofiUnwrappedNext = prev.rofi-unwrapped.overrideAttrs (old: {
    version = "2.0.0-dev";

    src = prev.fetchFromGitHub {
      owner = "davatorium";
      repo = "rofi";
      rev = "7575b70967c6ea747ecdeb4e54dc88fbf3939e6d";
      fetchSubmodules = true;
      hash = "sha256-wBgVWkrSS5po/J5GzkoAOWrBdW5wjR5MuC0dlGT8dNI=";
    };
  });
in
{
  rofi-unwrapped = rofiUnwrappedNext;

  rofi = prev.rofi.override {
    rofi-unwrapped = rofiUnwrappedNext;
  };

  rofi-next = final.rofi;
  rofi-unwrapped-next = final.rofi-unwrapped;
}
