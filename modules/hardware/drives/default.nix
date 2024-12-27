{ pkgs, settings, secrets, ... }:
let
  matchHostname = hostname:
    if hostname == "nixos" then [ ./home.nix ]
    else if hostname == "MarcoMNix" then [ ./school.nix ]
    else throw "Unsupported Host in ${toString ././default.nix}";
in
{

  environment.systemPackages = with pkgs; [
    gnome-disk-utility # gui for disk partitioning

    ntfs3g
    mdadm # for managing RAID arrays in Linux
    lvm2 # for LVM support

    udiskie # for automatic mounting of USB drives

    jmtpfs # for FTP with android phones

    nfs-utils # for mounting nfs drive

    exfatprogs # for exfat support

    xfsprogs # for xfs support

    bcache-tools # for ssd caching

    sysstat

    smartmontools
  ];

  boot.initrd = {
    # enable nfs support on boot
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };
  users.users.${settings.userDetails.username}.extraGroups = [ "storage" ];


  services = {
    devmon.enable = true; # an automatic device mounting daemon
    gvfs.enable = true; # Git Virtual File System
    udisks2.enable = true;
  };


  imports = matchHostname settings.userDetails.hostname;
}
