{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    discord
    signal-desktop
    whatsapp-for-linux
  ];
}
