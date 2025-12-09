{ ... }: {
  boot.kernelParams = [ "pcie_port_pm=off" "pci=no_d3cold" ]; # doesnt seem to be working
}
