{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    disabledPlugins = ["sap"];
    # sudo rfkill unblock bluetooth
  };
}
