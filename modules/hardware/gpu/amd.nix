{ ... }:
{
  # Enable AMDGPU Drivers
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu-pro" ];

  hardware.graphics = {
    enable = true;
    #driSupport = true;

    extraPackages = with pkgs; [
      amdvlk
      # rocmPackages.clr.icd
      #mesa
    ];

  };
  
  environment.systemPackages = with pkgs; [
    sigil # broken with nvidia so imported there
    wayland # broken with nvidia so imported there
  ]

}