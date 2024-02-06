{
  boot = {
    loader = { 
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        netbootxyz.enable = true;
      };
      timeout = 1;
    };
  };
}
