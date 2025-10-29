{ pkgs, ... }: {
  services.clamav = {
    package = pkgs.clamav;
    # Run the clamd daemon so on-demand scans are fast with `clamdscan`
    daemon = {
      # Do NOT keep the daemon in memory
      enable = false;
      settings = {
        # Logging
        LogSyslog = true;
        ExtendedDetectionInfo = true;

        # Exclusions (NixOS-friendly)
        ExcludePath = [ "^/nix/store/" "^/proc/" "^/sys/" "^/dev/" "^/run/" ];
      };
    };

    updater = {
      enable = true;
      interval = "hourly";
      frequency = 2;
      settings = {
        # Make clamd reload DB immediately after updates
        NotifyClamd = "/etc/clamav/clamd.conf";

        # (optional) log to journald/syslog
        LogSyslog = true;
      };
    };

    # Do NOT enable the scheduled scanner
    scanner.enable = false;
  };
}
