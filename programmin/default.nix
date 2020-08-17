{ pkgs, ... }:

{
  imports = [ ./prometheus ./mail ./jupyter ./rabbitmq ./postgres ./redis ];
}
