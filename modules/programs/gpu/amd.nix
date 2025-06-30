{ pkgs, ... }:
let
  nixpkgs.overlays = [ 
      (self: super: { btop = super.btop.override { rocmSupport = true; }; }) 
      (self: super: { btop = super.mission-center.override { rocmSupport = true; }; })
      (self: super: { btop = super.bottom.override { rocmSupport = true; }; })
    ];
in
{
  
  environment.systemPackages = with pkgs; [
    stable.sigil
    jellyfin-media-player

    mission-center
    bottom
    btop
  ];

}
