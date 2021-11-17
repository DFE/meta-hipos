FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Original: volatiles = "cache run log lock tmp"
# We don't any of those in volatiles, so:
volatiles = ""
dirs755  = "/bin /boot /dev ${sysconfdir} ${sysconfdir}/default \
           ${sysconfdir}/skel /lib /mnt /proc ${ROOT_HOME} /run /sbin \
           ${prefix} ${bindir} ${docdir} /usr/games ${includedir} \
           ${libdir} ${sbindir} ${datadir} \
           ${datadir}/common-licenses ${datadir}/dict ${infodir} \
           ${mandir} ${datadir}/misc ${localstatedir} \
           ${localstatedir}/backups ${localstatedir}/lib \
           /sys ${localstatedir}/lib/misc ${localstatedir}/spool \
           ${localstatedir}/volatile \
           ${localstatedir}/volatile/log \
           /media \
	    ${localstatedir}/cache \
            ${localstatedir}/log \
            ${localstatedir}/tmp \
            ${localstatedir}/volatile/tmp \
            /run \
           "

