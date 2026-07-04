final: prev:
let
  rofiUnwrappedNext = prev.rofi-unwrapped.overrideAttrs (old: {
    version = "2.0.0-dev";

    src = prev.fetchFromGitHub {
      owner = "davatorium";
      repo = "rofi";
      rev = "b447eba2fc57f8673be324296a6f459d33d37c46";
      fetchSubmodules = true;
      hash = "sha256-heXj9ZBT/7o0u2cqZQIHpggOPGI3vskKzlZvPhms+co=";
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
