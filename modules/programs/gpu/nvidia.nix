{ config, pkgs, lib, settings, ... }:
let
  # for firefox config
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };

  # this is related to an issue with nvidia, I believe, not wayland but setting backend as xcb seems to fix playback issues
  jellyfin-wayland = pkgs.stable.jellyfin-media-player.overrideAttrs (prevAttrs: {
    nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ])
      ++ [ pkgs.makeBinaryWrapper ];
    postInstall = (prevAttrs.postInstall or "") + ''
      wrapProgram $out/bin/jellyfinmediaplayer --set QT_QPA_PLATFORM xcb 
    '';
  });
  # seemed to have trouble rendering on wayland w/ nvidia gpu, setting backend as xcb seems to fix them
  sigil-wayland = pkgs.sigil.overrideAttrs (prevAttrs: {
    nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ])
      ++ [ pkgs.makeBinaryWrapper ];
    postInstall = (prevAttrs.postInstall or "") + ''
      wrapProgram $out/bin/sigil --set QT_QPA_PLATFORM xcb 
    '';
  });

  nixpkgs.overlays = [ 
      (self: super: { btop = super.btop.override { cudaSupport = true; }; }) 
      (self: super: { btop = super.mission-center.override { cudaSupport = true; }; })
      (self: super: { btop = super.bottom.override { cudaSupport = true; }; })
    ];

in {

  environment.systemPackages = with pkgs; [
    # more nvidia bullshit
    egl-wayland

    nvidia-vaapi-driver # recommended for firefox for nvidia hardware acceleration

    sigil-wayland # override because its broken on Nvidia
    jellyfin-wayland # override because its broken on Nvidia

    # in theory, should let nvidia gpu show up in these apps, idk though
    mission-center
    bottom
    btop
  ];

  programs.firefox = {
    wrapperConfig = {
      __NV_PRIME_RENDER_OFFLOAD = "1";
      __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      # nvidia vaapi
      MOZ_DISABLE_RDD_SANDBOX = "1";
      LIBVA_DRIVER_NAME = "nvidia";
    };
    policies = {
      Preferences = {
        # nvidia support
        "media.ffmpeg.vaapi.enabled" = lock-true;
        "media.rdd-ffmpeg.enabled" = lock-true;
        "media.av1.enabled" = lock-false;
        "gfx.x11-egl.force-enabled" = lock-true;
        "widget.dmabuf.force-enabled" = lock-true;
      };
    };
  };
}
