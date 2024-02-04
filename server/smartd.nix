{
  services.smartd = {
    enable = true;
    notifications = {
      wall.enable = false;
      mail = {
        enable = true;
        recipient = "smartd@mailrise.xyz";
      };
    };
  };
  
  tastypi.mailrise.smartd = {
    gotify = {
      token = (import ../secrets/gotify.nix).smartd;
      priority = "high";
    };
    mailrise.title_template = "$subject";
  };
}
