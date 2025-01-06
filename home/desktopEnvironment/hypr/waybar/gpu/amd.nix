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

            # Fetch GPU usage percentage
            gpu_usage=$(cat "$hwmon_path/device/gpu_busy_percent" 2>/dev/null || echo "N/A")

            # Fetch GPU temperature
            gpu_temp=$(cat "$hwmon_path/temp1_input" 2>/dev/null || echo "N/A")
            gpu_temp=$(echo "scale=1; $gpu_temp / 1000" | bc)  # Convert from millidegrees to degrees Celsius

            # Fetch total and used memory
            vram_usage=$(cat "$hwmon_path/device/mem_info_vram_used" 2>/dev/null || echo "0")
            vram_total=$(cat "$hwmon_path/device/mem_info_vram_total" 2>/dev/null || echo "0")
            used_memory=$(echo "scale=2; $vram_usage / 1048576" | bc)  # Convert to MiB
            total_memory=$(echo "scale=2; $vram_total / 1048576" | bc)  # Convert to MiB

            # Fetch GPU name
            gpu_name=$(glxinfo | grep "Device" | cut -d ':' -f2 | xargs || echo "N/A")

            # Create the JSON output
            json_output=$(cat <<EOF
            {"text": "$gpu_usage","tooltip": "GPU Name: $gpu_name\nUsed Memory: $used_memory MiB / $total_memory MiB\nTemperature: $gpu_temp°C"}
            EOF
            )

            # Output the JSON
            echo "$json_output"

          '';
        };
      };
    };
  };
}
