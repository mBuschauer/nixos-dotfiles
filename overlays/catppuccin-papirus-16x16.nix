final: prev: {
  catppuccin-papirus-folders =
    prev.catppuccin-papirus-folders.overrideAttrs (old: {
      installPhase = (old.installPhase or "") + ''
        # Remove 16x16 folder icons so GTK falls back to 22x22 (Catppuccin-colored)
        for theme in "$out"/share/icons/*; do
          if [ -d "$theme/16x16/places" ]; then
            rm -rf "$theme"/16x16/places/
          fi

          gtk-update-icon-cache --force "$theme" >/dev/null 2>&1 || true
        done
      '';
    });
}
