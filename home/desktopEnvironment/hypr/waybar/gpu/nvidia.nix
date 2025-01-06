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
          exec = pkgs.writeShellScript "get_nvidia_gpu" ''
            # Fetch GPU usage percentage
            gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

            # Fetch GPU temperature
            gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

            # Fetch driver version
            driver_version=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)

            # Fetch total and used memory
            total_memory=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)
            used_memory=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)

            # Fetch GPU name
            gpu_name=$(nvidia-smi --query-gpu=name --format=csv,noheader)

            # Create the JSON output
            json_output=$(cat <<EOF
            {"text": "$gpu_usage","tooltip": "GPU Name: $gpu_name\nUsed Memory: $used_memory MiB / $total_memory MiB\nTemperature: $gpu_temp°C\nDriver Version: $driver_version"}
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
