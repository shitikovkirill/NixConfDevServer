{ lib, ... }:
let inherit (lib) literalExample mkOption nameValuePair types;
in {
  port = mkOption {
    type = types.int;
    description = "Database port.";
    default = 3306;
    defaultText = "3306";
  };

  user = mkOption {
    type = types.str;
    default = "db_user";
    description = "Database user.";
  };

  password = mkOption {
    type = types.str;
    default = "qwerty";
    example = "password";
    description = ''
      Password field.
    '';
  };
}
