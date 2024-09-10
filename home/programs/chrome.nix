{ pkgs, lib, ... }:
let
  createChromiumExtensionFor = browserVersion: { id, sha256, version }:
  {
    inherit id;
      crxPath = builtins.fetchurl {
        url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
        name = "${id}.crx";
        inherit sha256;
      };
      inherit version;
    };
  createChromiumExtension = createChromiumExtensionFor (lib.versions.major pkgs.ungoogled-chromium.version);
in
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      (createChromiumExtension {
        # ublock origin
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        sha256 = "sha256:06k70762vh79ak1d2gsrx9faadzj0gjqa4yz9x7vk9m7k85jp69p";
        version = "1.59.0";
      })
      (createChromiumExtension {
        # material simple dark
        id = "ookepigabmicjpgfnmncjiplegcacdbm";
        sha256="sha256:0lbk1gak6z1dinwn6nmvg9f6ii4f075zyjy45j8n8cwm8m15cd3z";
        version = "2.60";
      })
      (createChromiumExtension {
        # Hover Zoom + 
        id = "pccckmaobkjjboncdfnnofkonhgpceea";
        sha256="sha256:1879jikj8c02jcq3h1nhhkj774c42hvbnqc5f11y7qy7acqg6j1r";
        version="1.0.219";
      })
      (createChromiumExtension {
        # bitwarden 
        id = "nngceckbapebfimnlniiiahkandclblb";
        sha256="sha256:0yssxmn6hkp6l1r3c0vnw4jsz4r9sdw356prbydg1n1samzhhqyk";
        version="2024.8.1";
      })
      #(createChromiumExtension {
      #  # Hive AI detector
      #  id = "cmeikcgfecnhojcbfapbmpbjgllklcbi";
      #  sha256="sha256:0m60hndms87v0y9x94400bkxllzqv030kwvr0bgcb7p74jn31qr5";
      #  version="0.0.8";
      # })
      (createChromiumExtension {
        # sponsor block
        id="mnjggcdmjocbbbhaepdhchncahnbgone";
        sha256="sha256:092122qqz60jyqa5nfvd7iqx9vhai0sh48s8ys1nrrfympzljign";
        version="5.7";
      })
    ];
  };
}
