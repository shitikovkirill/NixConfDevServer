{ pkgs, ... }:

{
  imports = [ ./prometheus ./mail ./jupyter ./rabbitmq ];
}
