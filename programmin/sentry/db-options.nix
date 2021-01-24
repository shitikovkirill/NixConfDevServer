{ lib, ... }:
let inherit (lib) literalExample mkOption nameValuePair types;
in {
  host = mkOption {
    default = "localhost";
    type = types.str;
    description = ''
      Database host
    '';
  };

  port = mkOption {
    type = types.int;
    description = "Database port.";
    default = 5432;
    defaultText = "5432";
  };

  name = mkOption {
    type = types.str;
    default = "sentry";
    description = "Database name.";
  };

  user = mkOption {
    type = types.str;
    default = "sentry";
    description = "Database user.";
  };

  password = mkOption {
    type = types.str;
    default = "sentry";
    example = "password";
    description = ''
      Password field.
    '';
  };
}
