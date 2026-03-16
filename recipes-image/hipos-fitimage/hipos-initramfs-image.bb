# SPDX-License-Identifier: MIT
# Copyright (C) 2025 iris-GmbH infrared & intelligent sensors

inherit only-for-hipos-cyber-security

include recipes-core/images/core-image-initramfs-boot.bb

INITRAMFS_SCRIPTS += " \
    initramfs-module-hipos-mount \
"
