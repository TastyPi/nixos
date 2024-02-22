{ pkgs, ... }:
{
  users.users.graham = {
    description = "Graham Rogers";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    shell = pkgs.zsh;
    uid = 1000;
  };
}
