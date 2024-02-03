{
  console.keyMap = "uk";
  i18n = rec {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LANGUAGE = "en_GB:en";
      LC_ALL = defaultLocale;
    };
  };
  services.xserver.xkb.layout = "gb";
  time.timeZone = "Europe/London";
}
