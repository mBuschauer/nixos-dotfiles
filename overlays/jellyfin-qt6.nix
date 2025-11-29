self: super:

let
  jellyfinMediaPlayerQt6 = {
    lib,
    SDL2,
    cmake,
    fetchFromGitHub,
    fribidi,
    kdePackages,
    libGL,
    libX11,
    libXrandr,
    libass,
    libsysprof-capture,
    libunwind,
    libvdpau,
    mpv,
    ninja,
    pkg-config,
    python3,
    qtbase,
    qtdeclarative,
    qttools,
    qtwayland,
    qtwebchannel,
    qtwebengine,
    stdenv,
    wrapQtAppsHook,
    withDbus ? stdenv.hostPlatform.isLinux,
  }:

  stdenv.mkDerivation rec {
    pname = "jellyfin-media-player";
    version = "6c7a37d5e61da281e4cc4b1d51892f785e9566ad";

    src = fetchFromGitHub {
      owner = "jellyfin";
      repo  = "jellyfin-media-player";
      rev   = version;
      sha256 = "sha256-AHYeLxlv+YH1sD6QebEn3qLu//aFeG8wqdQ35W6oZ1s=";
    };

    patches = [
      (super.path + "/pkgs/applications/video/jellyfin-media-player/disable-update-notifications.patch")
    ];

    buildInputs = [
      SDL2
      libass
      libGL
      libX11
      libXrandr
      libvdpau
      mpv
      kdePackages.mpvqt
      qtbase
      qttools
      qtdeclarative
      qtwebchannel
      qtwebengine
      libsysprof-capture
      libunwind
      fribidi
    ] ++ lib.optionals stdenv.hostPlatform.isLinux [
      qtwayland
    ];

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
      python3
      wrapQtAppsHook
    ];

    cmakeFlags = [
      "-DQTROOT=${qtbase}"
      "-GNinja"
      "-DUSE_STATIC_MPVQT=OFF"
      "-DQt6_DIR=${qtbase}/lib/cmake/Qt6"
    ] ++ lib.optionals (!withDbus) [
      "-DLINUX_X11POWER=ON"
    ];
  };
in {
  jellyfin-media-player = super.qt6Packages.callPackage jellyfinMediaPlayerQt6 { };
}