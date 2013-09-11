# bbapped to openembedded-core/meta/recipes-connectivity/connman/connman_1.12.bb
# install connmanctl

PR_append = "+r1"

FILES_${PN} += "/usr/sbin/connmanctl "

do_install_append () {
  install -m 0755 ${WORKDIR}/connman-1.17/client/connmanctl ${D}${sbindir}
}
