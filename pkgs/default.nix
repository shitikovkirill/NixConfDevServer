{ lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ git w3m micro ];
}
