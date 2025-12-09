{ pkgs, ... }: {
  # Enable AMDGPU Drivers
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu-pro" ];

  hardware.graphics = {
    enable = true;
    #driSupport = true;

    extraPackages = with pkgs;
      [
        # amdvlk
        rocmPackages.clr
        rocmPackages.clr.icd
        rocmPackages.rocminfo
        rocmPackages.rocm-smi
        mesa
      ];

  };

  environment.systemPackages = with pkgs;
    [

    ];

}
