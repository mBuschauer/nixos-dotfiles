{
  pkgs,
  settings,
  secrets,
  ...
}:
let
  matchHostname =
    hostname:
    if hostname == "nixos" then
      [ ./home.nix ]
    else if hostname == "MarcoMNix" then
      [ ./school.nix ]
    else
      throw "Unsupported Host in ${toString ././default.nix}";

in
{

  environment.systemPackages = with pkgs; [
    gnome-disk-utility # gui for disk partitioning

    # ntfs3g
    mdadm # for managing RAID arrays in Linux
    lvm2 # for LVM support

    # udiskie # for automatic mounting of USB drives

    # simple-mtpfs # for MTP with android phones

    nfs-utils # for mounting nfs drives

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
    gvfs.enable = true; # Git Virtual File System
    udisks2.enable = true;
  };

  home-manager.users.${settings.userDetails.username} = {
    # Automatic device mounting daemon
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";

      settings.program_options = {
        file_manager = pkgs.lib.getExe pkgs.nemo;
        event_hook =
          let
            play = pkgs.lib.getExe' pkgs.sox "play";
            notify-send = pkgs.lib.getExe' pkgs.libnotify "notify-send";

            chime =
              first: second:
              "${play} -q -n synth sin ${first}.00 sin ${second} synth sin fmod 220.00 fade l 0.010 1.350 1.250 pad 0 0.270 delay 0 0.220 remix - pad 0 0.70 vol -20.0dB reverb 50";

            hook = pkgs.writeShellScript "udiskie-hook" ''
              event="$1"
              device="$2"
              mount_path="$3"

              case "$event" in
                device_mounted)
                  ${chime "660.00" "1100.00"} &
                  ;;
                device_unmounted)
                  ${chime "1980" "1320"} &
                  ;;
              esac
            '';
          in
          "${hook} {event} {device_file} {mount_path}";
      };
    };
  };

  imports = matchHostname settings.userDetails.hostname;
}
