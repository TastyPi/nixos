{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ gh ];
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
      user = {
        email = "graham@rogers.me.uk";
        name = "Graham Rogers";
      };
    };
  };
}
