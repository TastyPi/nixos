{ pkgs, ... }:
{
  imports = [ ../graham.nix ];
  home.packages = with pkgs; [ discord signal-desktop whatsapp-for-linux ];
  systemd.user.services = {
    discord = {
      Unit.After = [ "graphical-session.target" ];
      Service.ExecStart = "${pkgs.discord}/bin/discord --start-minimized";
      Install.WantedBy = [ "graphical-session.target" ];
    };
    signal = {
      Unit.After = [ "graphical-session.target" ];
      Service.ExecStart = "${pkgs.signal-desktop}/bin/signal-desktop --start-in-tray";
      Install.WantedBy = [ "graphical-session.target" ];
    };
    whatsapp = {
      Unit.After = [ "graphical-session.target" ];
      # Does not have a commandline parameter to statr in the system tray
      Service.ExecStart = "${pkgs.whatsapp-for-linux}/bin/whatsapp-for-linux";
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
  xdg.enable = true;
}
