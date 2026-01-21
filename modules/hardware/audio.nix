{ pkgs, ... }: {
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    audio.enable = true;

    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        # Increase buffer to avoid stutter
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 256;
        "default.clock.max-quantum" = 1024;
        "default.clock.rate" = 48000;
      };
    };
    
  };

}
