{ pkgs, ... }:
{
  #boot.initrd.availableKernelModules = [ "amdgpu" "kvm-amd" ];
  environment.systemPackages = with pkgs; [
    libva-minimal
    libvdpau
    mesa_drivers
    vaapiVdpau
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
