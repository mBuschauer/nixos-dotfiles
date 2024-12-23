{ pkgs, settings, ... }:

{
  virtualisation = {
    # waydroid.enable = true;

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
        ovmf = {
          # UEFI support for Vms
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };

      };
    };

    #podman = {
    #  enable = true;

    #  dockerCompat = true;
    #  defaultNetwork.settings.dns_enabled = true;
    #};

    virtualbox.host = {
      enable = true;
      package = pkgs.virtualbox;
      enableExtensionPack = true;
      enableHardening = true;
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

    bottles # modern wine gui
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
