{ pkgs, ... }:

{
  imports = [ ./prometheus ./mail ./jupyter ];
}
