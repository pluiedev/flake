{
  perSystem = {pkgs, ...}: {
    packages = {
      blender-cuda = pkgs.blender.override {cudaSupport = true;};
    };
  };
}
