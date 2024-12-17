{ pkgs, settings, secrets, ... }:
{

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