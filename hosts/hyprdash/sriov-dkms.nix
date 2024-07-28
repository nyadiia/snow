{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kmod,
}:

stdenv.mkDerivation rec {
  name = "i915-sriov-dkms-${version}-${kernel.version}";
  version = "0-unstable-2024-07-25";

  src = fetchFromGitHub {
    owner = "strongtz";
    repo = "i915-sriov-dkms";
    rev = "fb2431a25a8e41bce949c22bb9fdc1c56054f9d2";
    sha256 = "1d9qpnmqa3pfwsrpjnxdz76ipk4w37bbxyrazchh4vslnfc886fx";
  };

  # sourceRoot = "source/linux/v4l2loopback";
  hardeningDisable = [
    "pic"
    "format"
  ]; # 1
  nativeBuildInputs = kernel.moduleBuildDependencies; # 2

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}" # 3
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" # 4
    "INSTALL_MOD_PATH=$(out)" # 5
  ];

  meta = {
    description = "A kernel module to enable SRIOV on new Intel GPUs";
    homepage = "https://github.com/strongtz/i915-sriov-dkms";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.nyadiia ];
    platforms = lib.platforms.linux;
  };
}
