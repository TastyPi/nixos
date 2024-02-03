{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ gh ];
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
        ff = "only";
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
