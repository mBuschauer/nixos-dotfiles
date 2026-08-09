{ ... }:
{
  # nvidia needs some variables passed to it
  wayland.windowManager.hyprland.settings.env = [
    {
      _args = [
        "GBM_BACKEND"
        "nvidia-drm"
      ];
    }
    {
      _args = [
        "LIBVA_DRIVER_NAME"
        "nvidia"
      ];
    }
    {
      _args = [
        "__GLX_VENDOR_LIBRARY_NAME"
        "nvidia"
      ];
    }
    {
      _args = [
        "XDG_SESSION_TYPE"
        "wayland"
      ];
    }
    {
      _args = [
        "NVD_BACKEND"
        "direct"
      ];
    }
  ];
}
