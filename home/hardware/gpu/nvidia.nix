{ ... }:
{
  # nvidia needs some variables passed to it
  wayland.windowManager.hyprland.settings = {
    "env" = [
      "GBM_BACKEND,nvidia-drm"
      "LIBVA_DRIVER_NAME,nvidia"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "NVD_BACKEND,direct"
    ];
  };
}
