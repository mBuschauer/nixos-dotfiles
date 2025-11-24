{ pkgs, settings, ... }:

{
  # virtualisation = {
  #   waydroid = {
  #     enable = false;
  #     package = pkgs.waydroid;
  #   };

  #   spiceUSBRedirection.enable = true;

  #   libvirtd = {
  #     enable = true;

  #     qemu = {
  #       package = pkgs.qemu_full;
  #       swtpm = {
  #         # tpm emulator
  #         enable = true;
  #         package = pkgs.swtpm;
  #       };

  #     };
  #   };

  #   #podman = {
  #   #  enable = true;

  #   #  dockerCompat = true;
  #   #  defaultNetwork.settings.dns_enabled = true;
  #   #};

  #   virtualbox.host = {
  #     enable = false;
  #     package = pkgs.virtualbox;
  #     enableExtensionPack = true;
  #     enableHardening = true;
  #   };

  #   vmVariant = {
  #     # following configuration is added only when building VM with build-vm
  #     virtualisation = {
  #       memorySize = 4096; # Use 2048MiB memory.
  #       cores = 4;
  #     };
  #   };
  #   vmVariantWithBootLoader = {
  #     virtualisation = {
  #       memorySize = 4096; # Use 2048MiB memory.
  #       cores = 4;
  #     };
  #   };
  # };

  # programs.virt-manager = {
  #   enable = true; # front end for qemu
  #   package = pkgs.virt-manager;
  # };

  # environment.systemPackages = with pkgs; [
  #   # podman-compose
  #   spice
  #   spice-gtk
  #   spice-protocol
  #   virt-manager
  #   virt-viewer
  #   win-spice
  #   virtio-win

  #   # (pkgs.bottles.override { removeWarningPopup = true; }) # modern wine gui
  # ];

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

  # kvm kernel flags for AMD & AMD cpus what want to run a Mac VM
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
    options kvm_intel nested=1
    options kvm_intel emulate_invalid_guest_state=0
    options kvm ignore_msrs=1 report_ignored_msrs=0
  '';

}
