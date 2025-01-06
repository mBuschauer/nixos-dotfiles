{ pkgs, settings, secrets, ... }:
{
  fileSystems."/mnt/sda1" = {
    device = "/dev/sda1";
    fsType = "ntfs";
    options = [
      "soft" # return errors to client when access is lost, instead of waiting indefinitely
      "softreval" # use cache even when access is lost
      "auto"
      "nofail" # system won't fail if drive doesn't mount
      "users" # allows any user to mount and unmount
    ];
  };


  fileSystems."/mnt/nvme0n1p4" = {
    device = "/dev/nvme0n1p4";
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
    device = "${secrets.homeServerIP}:/raid";
    fsType = "nfs";
    options = [
      "noauto"
      "_netdev"
      "x-systemd.automount"
      "x-systemd.requires=tailscaled.service"
      "nofail"
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
      "x-systemd.requires=tailscaled.service"
      "username=${secrets.nasUser}"
      "password=${secrets.nasPassword}"

      "uid=1000"
      "users"

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
