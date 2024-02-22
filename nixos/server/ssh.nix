{
  services.openssh = {
    enable = true;
    # Disable this before exposing it to the internet
    settings.PermitRootLogin = "yes";
  };
}
