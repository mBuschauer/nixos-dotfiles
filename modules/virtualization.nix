{ pkgs, settings, ... }: 

{ 
  virtualisation = {
    # waydroid.enable = true;

    spiceUSBRedirection.enable = true;

    libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };

    #podman = {
    #  enable = true;

    #  dockerCompat = true;
    #  defaultNetwork.settings.dns_enabled = true;
    #};
  };

  programs.virt-manager = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
   # podman-compose
    qemu
    spice
    spice-gtk
    spice-protocol
    virt-manager
    virt-viewer
    win-spice
    win-virtio 


    bottles # modern wine gui
  ];

  users.users.${settings.username}.extraGroups = [ "libvirtd" ];

  home-manager.users.${settings.username} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
