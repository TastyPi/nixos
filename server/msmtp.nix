{ config, ... }:
{
  programs.msmtp = {
    enable = config.tastypi.mailrise != {};
    accounts = {
      default = {
        host = "localhost";
        port = 8025;
        from = "server@rogers.me.uk";
      };
    };
  };
}
