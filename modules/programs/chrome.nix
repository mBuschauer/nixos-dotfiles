{ pkgs, lib, ... }:
let
  braveWithWebGL =
    (pkgs.brave.override {
      enableVulkan = true;
      vulkanSupport = true;
    }).overrideAttrs
      (prevAttrs: {
        nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.makeBinaryWrapper ];

        postInstall = (prevAttrs.postInstall or "") + ''
          wrapProgram $out/bin/brave \
            --add-flags "--enable-features=Vulkan" \
            --set ozone-platform x11
        '';
      });

in
{
  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "ookepigabmicjpgfnmncjiplegcacdbm" # matrial simple dark
      "pccckmaobkjjboncdfnnofkonhgpceea" # hover zoom +
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsor block
    ];

  };

  environment.systemPackages = with pkgs; [
    braveWithWebGL
  ];
  # home-manager.users.${settings.userDetails.username} = {
  #   programs.chromium = {
  #     enable = true;
  #     # package = pkgs.ungoogled-chromium.override { enableWideVine = true; };
  #     package = pkgs.chromium.override { enableWideVine = true; };
  #     commandLineArgs = [
  #       # "--enable-features=AcceleratedVideoEncoder"
  #       # "--ignore-gpu-blocklist"
  #       # "--enable-zero-copy"
  #     ];

  #     extensions = [
  #       { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
  #       { id = "ookepigabmicjpgfnmncjiplegcacdbm"; } # matrial simple dark
  #       { id = "pccckmaobkjjboncdfnnofkonhgpceea"; } # hover zoom +
  #       { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
  #       { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsor block
  #     ];
  #   };

  #   home.packages = with pkgs; [ braveWithWebGL ];
  # };
}
