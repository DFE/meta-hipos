# busybox tar (v1.27.2, sumo) has changed its behavior. For example, unsafe
# symlinks are skipped.
#
# tar -xjf Angstrom-hydraip-prodimage-glibc-ipk-v2018.06-himx0294.rootfs.tar.bz2
# tar: skipping unsafe symlink to '../run/lock' in archive, set EXTRACT_UNSAFE_SYMLINKS=1 to extract
#
# To keep the previous behavior, an environment variable must bes set. Since
# legacy scripts cannot set this envrionment variable afterwards, the
# environment variable is set system-wide by setting in this file in
# /etc/profle.d/ directory.

export EXTRACT_UNSAFE_SYMLINKS=1
