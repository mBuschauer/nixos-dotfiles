{ pkgs, lib, ... }:
let
  createChromiumExtensionFor = browserVersion:
    { id, sha256, version }: {
      inherit id;
      crxPath = builtins.fetchurl {
        url =
          "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
        name = "${id}.crx";
        inherit sha256;
      };
      inherit version;
    };
  createChromiumExtension = createChromiumExtensionFor
    (lib.versions.major pkgs.ungoogled-chromium.version);


  braveWithWebGL = (pkgs.brave.override {
    enableVulkan = true;
    vulkanSupport = true;
  }).overrideAttrs (prevAttrs: {
    nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ])
      ++ [ pkgs.makeBinaryWrapper ];

    postInstall = (prevAttrs.postInstall or "") + ''
      wrapProgram $out/bin/brave \
        --add-flags "--enable-features=Vulkan" \
        --set ozone-platform x11
    '';
  });

in {
  programs.chromium = {
    enable = true;
    # package = pkgs.ungoogled-chromium.override { enableWideVine = true; };
    package = pkgs.chromium.override { enableWideVine = true; };
    commandLineArgs = [
      # "--enable-features=AcceleratedVideoEncoder"
      # "--ignore-gpu-blocklist"
      # "--enable-zero-copy"
    ];

    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "ookepigabmicjpgfnmncjiplegcacdbm"; } # matrial simple dark
      { id = "pccckmaobkjjboncdfnnofkonhgpceea"; } # hover zoom +
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsor block
    ];
  };

  home.packages = with pkgs; [ braveWithWebGL ];
}
