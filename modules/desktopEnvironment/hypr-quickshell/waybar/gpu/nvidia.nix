{ pkgs, inputs, settings, secrets, ... }: {
  programs.waybar = {
    settings = {
      mainBar = {
        "custom/gpu" = {
          format = "󰨇  {}%";
          tooltip = true;
          return-type = "json";
          interval = 1;
          on-click = "gpustat";
          exec = pkgs.writeShellScript "get_nvidia_gpu" ''
            # Gather raw values (strip newlines just in case)
            gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | tr -d '\n')
            gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader | tr -d '\n')
            driver_version=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | tr -d '\n')
            total_memory=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader | tr -d '\n')
            used_memory=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader | tr -d '\n')
            gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader | tr -d '\n')

            # Build tooltip with real newlines
            tooltip=$(printf 'GPU Name: %s\nUsed Memory: %s MiB / %s MiB\nTemperature: %s°C\nDriver Version: %s' \
              "$gpu_name" "$used_memory" "$total_memory" "$gpu_temp" "$driver_version")

            # Emit compact JSON
            jq -n -c --arg text "$gpu_usage" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'
          '';
        };
      };
    };
  };
}
