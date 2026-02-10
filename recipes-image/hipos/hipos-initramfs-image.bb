# SPDX-License-Identifier: MIT
# Copyright (C) 2025 iris-GmbH infrared & intelligent sensors

include recipes-core/images/core-image-initramfs-boot.bb

INITRAMFS_SCRIPTS += " \
    initramfs-module-hipos-mount \
"
