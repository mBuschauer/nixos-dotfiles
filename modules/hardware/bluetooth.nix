{ config, pkgs, ... }: {
  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        ControllerMode = "bredr";
        experimental = true; # show battery

        # https://www.reddit.com/r/NixOS/comments/1ch5d2p/comment/lkbabax/
        # for pairing bluetooth controller
        Privacy = "device";
        JustWorksRepairing = "always";
        Class = "0x000100";
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };
  services.blueman.enable = true;

  # Enable the xpadneo driver for Xbox One wireless controllers
  # if not working, try running `sudo btmgmt le on`
  hardware.xpadneo.enable = true;

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
    extraModprobeConfig = ''
      # disable Enhanced Retransmission Mode so that controllers work
      options bluetooth disable_ertm=Y

      # Core: disable client power-save (reduces radio state changes)
      options rtw89core disable_ps_mode=Y

      # PCIe: disable ASPM/CLKREQ that can cause hiccups on some 8852C* boards
      options rtw89pci disable_clkreq=Y disable_aspm_l1=Y disable_aspm_l1ss=Y

      options btusb enable_autosuspend=N
    '';

  };
}
