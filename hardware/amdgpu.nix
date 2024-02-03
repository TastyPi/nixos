{ pkgs, ... }:
{
  #boot.initrd.availableKernelModules = [ "amdgpu" "kvm-amd" ];
  environment.systemPackages = with pkgs; [
    libva-minimal
    libvdpau
    mesa_drivers
    vaapiVdpau
  ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
