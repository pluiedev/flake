{
  pkgs,
  lib,
  ...
}: {
  boot.kernelModules = ["vfio-pci"];
  boot.blacklistedKernelModules = ["nouveau"];
  boot.kernelParams = ["intel_iommu=on"];

  services.xserver.videoDrivers = lib.mkForce [];

  systemd.tmpfiles.rules = ["f /dev/shm/looking-glass 0660 leah kvm -"];

  hm.home.packages = [pkgs.looking-glass-client];

  hm.xdg.configFile."looking-glass/client.ini".text = lib.generators.toINI {} {
    win = {
      size = "1920x1200";
      autoResize = "yes";
      fullScreen = "no";
    };
    input = {
      autoCapture = "yes";
      escapeKey = "KEY_F3";
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
    spiceUSBRedirection.enable = true;
  };

  services.spice-vdagentd.enable = true;

  programs.virt-manager.enable = true;

  roles.base.user.extraGroups = ["libvirtd"];

  environment.systemPackages = with pkgs; [
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
  ];

  hm.dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
