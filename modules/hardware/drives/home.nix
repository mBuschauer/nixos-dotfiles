{ pkgs, settings, secrets, ... }:
{
  environment.systemPackages = with pkgs; [
    gnome-disk-utility # gui for disk partitioning

    ntfs3g
    mdadm # for managing RAID arrays in Linux
    lvm2 # for LVM support

    udiskie # for automatic mounting of USB drives

    jmtpfs # for FTP with android phones

    nfs-utils # for mounting nfs drive
  ];

  boot.initrd = {
    # enable nfs support on boot
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };
  users.users.${settings.username}.extraGroups = [ "storage" ];

  services = {
    devmon.enable = true; # an automatic device mounting daemon
    gvfs.enable = true; # Git Virtual File System
    udisks2.enable = true;
  };

  fileSystems."/mnt/nvme0n1p3" = {
    device = "/dev/nvme0n1p3";
    fsType = "ntfs";
    options = [
      "default"
    ];
  };
  fileSystems."/mnt/sda2" = {
    label = "Backup";
    fsType = "ntfs";
    options = [
      "default"
    ];
  };

  fileSystems."/mnt/sdb2" = {
    label = "Games";
    fsType = "ntfs";
    options = [
      "default"
    ];
  };
  fileSystems."/mnt/sdc2" = {
    label = "Content";
    fsType = "ntfs";
    options = [
      "default"
    ];
  };

  services.rpcbind.enable = true;

  fileSystems."/mnt/Storage" = {
    device = "//${secrets.nasIP}/Marco";
    fsType = "cifs";
    options = [
      "noauto"
      "_netdev"
      "x-systemd.automount"
      "username=${secrets.nasUser}"
      "password=${secrets.nasPassword}"

      "uid=1000"
      "users"

    ];
  };
  fileSystems."/mnt/Documents" = {
    device = "//${secrets.nasIP}/Documents";
    fsType = "cifs";
    options = [
      "noauto"
      "_netdev"
      "x-systemd.automount"
      "username=${secrets.nasUser}"
      "password=${secrets.nasPassword}"

      "uid=1000"
      "users"

    ];
  };
  fileSystems."/mnt/Calibre" = {
    device = "${secrets.homeServerIP}:/Calibre";
    fsType = "nfs";
    options = [
      "_netdev"
      "x-systemd.automount"

      "users"
      "default"
    ];
  };
}