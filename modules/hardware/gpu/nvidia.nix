{ config, pkgs, lib, ... }:
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

in
{
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.extraModprobeConfig = ''
      options nvidia_drm modeset=1 fbdev=1
    '';
  boot.kernelModules = ["nvidia-uvm"]; # enables cuda support apparently?

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.systemPackages = with pkgs; [
    # more nvidia bullshit
    egl-wayland

    nvidia-vaapi-driver # recommended for firefox for nvidia hardware acceleration
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
