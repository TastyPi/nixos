{ lib, ... }:
with lib;
with types;
{
  options.tastypi = {
    caddy = mkOption {
      default = {};
      type = attrsOf (submodule {
        options = {
          authelia = mkOption { default = false; type = types.bool; };
          endpoint = mkOption { type = types.str; };
        };
      });
    };
    
    mailrise = mkOption {
      default = {};
      type = attrsOf (submodule {
        options = {
          gotify = mkOption {
            type = submodule {
              options = {
                token = mkOption { type = str; };
                priority = mkOption { default = "normal"; type = enum [ "low" "moderate" "normal" "high" ]; };
              };
            };
          };
          mailrise = mkOption { default = {}; type = attrs; };
        };
      });
    };
  };
}
