{
  console.keyMap ="uk";
  services.xserver.xkb.layout = "gb";
  time.timeZone = "Europe/London";
  i18n = rec {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LANGUAGE = "en_GB:en";
      LC_ALL = defaultLocale;
    };
  };
}
