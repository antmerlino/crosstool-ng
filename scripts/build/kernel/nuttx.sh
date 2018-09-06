# This file declares functions to install the kernel headers for nuttx
# Copyright 2018 Verge Inc.

CT_DoKernelTupleValues() {
    CT_TARGET_KERNEL="nuttx"
}

# Download the kernel
do_kernel_get() {
    CT_Fetch NUTTX
    CT_Fetch NUTTX_APPS
}

# Extract kernel
do_kernel_extract() {
    CT_ExtractPatch NUTTX
    CT_ExtractPatch NUTTX_APPS
}

# Install kernel headers using headers_install from kernel sources.
do_kernel_headers() {
    local kernel_path
    local kernel_arch

    CT_DoStep INFO "Installing kernel headers"

    mkdir -p "${CT_BUILD_DIR}/build-kernel-headers"

    kernel_path="${CT_SRC_DIR}/nuttx"
    kernel_arch="${CT_ARCH}"

    cd ${kernel_path}

    CT_DoLog EXTRA "Configuring NuttX: ${CT_KERNEL_NUTTX_CONFIG}"
    CT_DoExecLog ALL                                         \
    ./tools/configure.sh -a ../nuttx-apps ${CT_KERNEL_NUTTX_CONFIG}

    CT_DoLog EXTRA "NuttX: make context"
    CT_DoExecLog ALL                                         \
    make context

    CT_DoLog EXTRA "Installing NuttX headers"
    CT_DoExecLog ALL                                         \
    cp -rL include/* ${CT_SYSROOT_DIR}/usr/include/

    CT_EndStep
}
