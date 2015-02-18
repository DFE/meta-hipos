# With yocto branch dizzy and machine himx0294 build of recipe u-boot-fw-uitls
# fail with following output:
#
# | In file included from /home/schuknecht/imoc-hipos-dfe-dizzy/hipos-dfe/build-closed/tmp-glibc/sysroots/himx0294/usr/include/features.h:389:0,
# |                  from /home/schuknecht/imoc-hipos-dfe-dizzy/hipos-dfe/build-closed/tmp-glibc/sysroots/himx0294/usr/include/fcntl.h:25,
# |                  from tools/env/fw_env_main.c:30:
# | /home/schuknecht/imoc-hipos-dfe-dizzy/hipos-dfe/build-closed/tmp-glibc/sysroots/himx0294/usr/include/gnu/stubs.h:7:29: fatal error: gnu/stubs-soft.h: No such file or directory
# |  # include <gnu/stubs-soft.h>
# |                              ^
# | compilation terminated.
#
# Such an error is described on the gcc mailing list.
#
# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=62099
#
# A solution is to add gcc configuration parameter --with-float=hard.
#
# Add gcc configuration parameter --with-float=hard for machine himx0294.

EXTRA_OECONF_himx0294 += "\
    --with-float=hard \
"

