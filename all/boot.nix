{
  boot = {
    loader = { 
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        netbootxyz.enable = true;
      };
      timeout = 1;
    };
  };
}
