{ pkgs, ... }:
{
  environment = {
    gnome.excludePackages = with pkgs; with gnome; [
      cheese
      eog
      epiphany
      evince
      geary
      gnome-connections
      gnome-contacts
      gnome-logs
      gnome-maps
      gnome-music
      gnome-photos
      gnome-themes-extra
      gnome-tour
      gnome-user-docs
      orca
      seahorse
      simple-scan
      yelp
    ];
    systemPackages = with pkgs; [
      firefox
      gnome-usage
      loupe
    ];
  };
  programs._1password-gui.enable = true;
  services = {
    gnome = {
      gnome-initial-setup.enable = false;
      gnome-online-accounts.enable = false;
      gnome-remote-desktop.enable = false;
      gnome-user-share.enable = false;
      rygel.enable = false;
    };
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager = {
        autoLogin = {
          enable = true;
          user = "graham";
        };
        gdm.enable = true;
      };
      excludePackages = with pkgs; [
        xorg.xorgserver.out
        xorg.xrandr
        xorg.xrdb
        xorg.setxkbmap
        xorg.iceauth
        xorg.xlsclients
        xorg.xset
        xorg.xsetroot
        xorg.xinput
        xorg.xprop
        xorg.xauth
        pkgs.xterm
        xorg.xf86inputevdev.out
      ];
    };
  };
  systemd.services = {
    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };
  users.users.graham.extraGroups = [ "networkmanager" ];
}
