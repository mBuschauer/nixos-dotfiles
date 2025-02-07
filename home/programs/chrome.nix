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
        sha256 = "sha256:0ycnkna72n969crgxfy2lc1qbndjqrj46b9gr5l9b7pgfxi5q0ll";
        version = "1.59.0";
      })
      (createChromiumExtension {
        # material simple dark
        id = "ookepigabmicjpgfnmncjiplegcacdbm";
        sha256 = "sha256:0lbk1gak6z1dinwn6nmvg9f6ii4f075zyjy45j8n8cwm8m15cd3z";
        version = "2.60";
      })
      (createChromiumExtension {
        # Hover Zoom + 
        id = "pccckmaobkjjboncdfnnofkonhgpceea";
        sha256 = "sha256:0ki0ggljak07slrd0n0lgs6s29a2db6dc6gxvmsn3z6jdikm7j2q";
        version = "1.0.219";
      })
      (createChromiumExtension {
        # bitwarden 
        id = "nngceckbapebfimnlniiiahkandclblb";
        sha256 = "sha256:1c59lmxj786w7vnynsmyd9b65c19vn7agnncbr7yz0kbf35yw7iw";
        version = "2024.8.1";
      })
      (createChromiumExtension {
        # sponsor block
        id = "mnjggcdmjocbbbhaepdhchncahnbgone";
        sha256 = "sha256:07g8278s55wzzjb7im3lirmq7aq0pb3zfgw8xly0wczwjz3mhzb6";
        version = "5.7";
      })
    ];
  };
}