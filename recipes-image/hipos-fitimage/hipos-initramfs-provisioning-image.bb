# SPDX-License-Identifier: MIT
# Copyright (C) 2026 iris-GmbH infrared & intelligent sensors

inherit only-for-hipos-cyber-security

include recipes-core/images/core-image-initramfs-boot.bb

INITRAMFS_SCRIPTS += " \
    initramfs-module-hipos-provisioning \
"
