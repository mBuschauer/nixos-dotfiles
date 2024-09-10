{ ... }:
{
  # nvidia needs some variables passed to it
  wayland.windowManager.hyprland = {
    "env" = [
      "GBM_BACKEND,nvidia-drm"
      "LIBVA_DRIVER_NAME,nvidia"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "NVD_BACKEND,direct"
    ];
  };  
}