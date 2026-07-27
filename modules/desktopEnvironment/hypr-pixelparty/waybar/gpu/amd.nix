{ pkgs, inputs, settings, secrets, ... }:
{
  programs.waybar = {
    settings = {
      mainBar = {
        "custom/gpu" = {
          format = "󰨇  {}%";
          tooltip = true;
          return-type = "json";
          interval = 1;
          on-click = "gpustat";
          exec = pkgs.writeShellScript "get_amd_gpu" ''
            # Set the path to the hwmon directory for the AMD GPU
            hwmon_path="/sys/class/hwmon/hwmon0"  # Adjust hwmon0 based on your system

            gpu_usage=$(cat "$hwmon_path/device/gpu_busy_percent" 2>/dev/null || echo "N/A")
            raw_temp=$(cat "$hwmon_path/temp1_input" 2>/dev/null || echo "0")
            gpu_temp=$(echo "scale=1; $raw_temp / 1000" | bc)
            vram_used=$(cat "$hwmon_path/device/mem_info_vram_used" 2>/dev/null || echo "0")
            vram_total=$(cat "$hwmon_path/device/mem_info_vram_total" 2>/dev/null || echo "0")
            used_memory=$(echo "scale=2; $vram_used / 1048576" | bc)
            total_memory=$(echo "scale=2; $vram_total / 1048576" | bc)
            gpu_name=$(glxinfo | grep "^Device" | cut -d ':' -f2 | xargs || echo "N/A")

            tooltip=$(printf 'GPU Name: %s\nUsed Memory: %s MiB / %s MiB\nTemperature: %s°C' "$gpu_name" "$used_memory" "$total_memory" "$gpu_temp")
            jq -n -c --arg text "$gpu_usage" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'
          '';
        };
      };
    };
  };
}
