{ lib, ... }:
with lib;
with types;
{
  options.tastypi = {
    caddy = mkOption {
      default = {};
      type = attrsOf (submodule {
        options = {
          authelia = mkOption {
            default = {};
            type = submodule {
              options = {
                enable = mkOption { default = false; type = bool; };
                match = mkOption { default = {}; type = attrs; };
              };
            };
          };
          endpoint = mkOption { type = str; };
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
