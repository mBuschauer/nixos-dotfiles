{ pkgs, settings, ... }:

{
  virtualisation = {
    waydroid = {
      enable = false;
      package = pkgs.waydroid;
    };

    spiceUSBRedirection.enable = true;

    libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu;
        swtpm = {
          # tpm emulator
          enable = true;
          package = pkgs.swtpm;
        };
        # ovmf = {
        #   # UEFI support for VMs
        #   enable = true;
        #   packages = [ pkgs.OVMFFull.fd ];
        # };

      };
    };

    #podman = {
    #  enable = true;

    #  dockerCompat = true;
    #  defaultNetwork.settings.dns_enabled = true;
    #};

    virtualbox.host = {
      enable = false;
      package = pkgs.virtualbox;
      enableExtensionPack = true;
      enableHardening = true;
    };

    vmVariant = {
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        memorySize = 4096; # Use 2048MiB memory.
        cores = 4;
      };
    };
    vmVariantWithBootLoader = {
      virtualisation = {
        memorySize = 4096; # Use 2048MiB memory.
        cores = 4;
      };
    };
  };

  programs.virt-manager = {
    enable = true; # front end for qemu
    package = pkgs.virt-manager;
  };

  environment.systemPackages = with pkgs; [
    # podman-compose
    spice
    spice-gtk
    spice-protocol
    virt-manager
    virt-viewer
    win-spice
    win-virtio

    # (pkgs.bottles.override { removeWarningPopup = true; }) # modern wine gui
  ];

  users.users.${settings.userDetails.username}.extraGroups = [
    "libvirtd"
    "vboxusers" # Adding users to the group vboxusers allows them to use the virtualbox functionality.
  ];

  # settings for qemu/kvm
  home-manager.users.${settings.userDetails.username} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
