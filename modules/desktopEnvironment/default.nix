{ settings, ... }:
let
  hasHyprland = deOptions:
    if builtins.elem "hyprland" deOptions then [ ./hyprland.nix ]
    else [ ];

  hasGnome = deOptions:
    if builtins.elem "gnome" deOptions then [ ./gnome.nix ]
    else [ ];

  hasKDE = deOptions:
    if builtins.elem "kde" deOptions then [ ./kde.nix ]
    else [ ];

  hasCosmic = deOptions:
    if builtins.elem "cosmic" deOptions then [ ./cosmic.nix ]
    else [ ];
  
  hasCinnamon = deOptions:
    if builtins.elem "cinnamon" deOptions then [ ./cinnamon.nix ]
    else [ ];
in
{
  imports = hasHyprland settings.customization.desktopEnvironment ++
    hasGnome settings.customization.desktopEnvironment ++ 
    hasKDE settings.customization.desktopEnvironment ++ 
    hasCosmic settings.customization.desktopEnvironment ++
    hasCinnamon settings.customization.desktopEnvironment;
}
