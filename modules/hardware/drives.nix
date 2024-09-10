{ pkgs, ... }:
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
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };

  # add support for external drives
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  fileSystems."/mnt/nvme0n1p3" = {
    device = "/dev/nvme0n1p3";
    fsType = "ntfs";
    options = [
      "soft" # return errors to client when access is lost, instead of waiting indefinitely
      "softreval" # use cache even when access is lost
      "auto"
      "nofail" # system won't fail if drive doesn't mount
      "users" # allows any user to mount and unmount
    ];
  };
  fileSystems."/mnt/sda2" = {
    label = "Backup";
    fsType = "ntfs";
    options = [
      "soft" # return errors to client when access is lost, instead of waiting indefinitely
      "softreval" # use cache even when access is lost
      "auto"
      "nofail" # system won't fail if drive doesn't mount
      "users" # allows any user to mount and unmount
    ];
  };

  fileSystems."/mnt/sdb2" = {
    label = "Games";
    fsType = "ntfs";
    options = [
      "soft" # return errors to client when access is lost, instead of waiting indefinitely
      "softreval" # use cache even when access is lost
      "auto"
      "nofail" # system won't fail if drive doesn't mount
      "users" # allows any user to mount and unmount
    ];
  };
  fileSystems."/mnt/sdc2" = {
    label = "Content";
    fsType = "ntfs";
    options = [
      "soft" # return errors to client when access is lost, instead of waiting indefinitely
      "softreval" # use cache even when access is lost
      "auto"
      "nofail" # system won't fail if drive doesn't mount
      "users" # allows any user to mount and unmount
    ];
  };

  services.rpcbind.enable = true;

  fileSystems."/mnt/Storage" = {
    device = "//192.168.0.8/Marco";
    fsType = "cifs";
    options = [
      "noauto"
      "_netdev"
      "x-systemd.automount"
  
      "uid=1000"
      "users"
    ];
  };
  # fileSystems."/mnt/Documents" = {
  #  device = "//192.168.0.8/Documents";
  #  fsType = "cifs";
  #  options = [
  #    "noauto"
  #    "_netdev"
  #    "x-systemd.automount"
  #
  #    "uid=1000"
  #    "users"
  #  ];
  #};
  #fileSystems."/mnt/Videos" = {
  #  device = "//192.168.0.8/Videos";
  #  fsType = "cifs";
  #  options = [
  #    "noauto"
  #    "_netdev"
  #    "x-systemd.automount"
  #
  #    "uid=1000"
  #    "users"
  #  ];
  #};
  fileSystems."/mnt/Calibre" = {
    device = "192.168.0.85:/Calibre";
    fsType = "nfs";
    options = [
      "noauto"
      "_netdev"
      "x-systemd.automount"
    ];
  };

  # fileSystems."/export/Maryland" = {
  #  device = "/home/marco/Desktop/Maryland";
  #  options = [ "bind" ];
  # };


  # services.nfs.server = {
  #  enable = true;
  #  exports = ''
  #    /export            *(rw,fsid=0,no_subtree_check)
  #    /export/Maryland    *(rw,nohide,insecure,no_subtree_check)
  #  '';
  # };

}
