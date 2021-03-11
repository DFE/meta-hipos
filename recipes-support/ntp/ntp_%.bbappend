PACKAGECONFIG_remove = "sntp"
PACKAGES_remove = "sntp"
SYSTEMD_PACKAGES_remove = "sntp"

do_install_append() {
    # Fix ntpd Permission denied HYP-25241
    # As long as the ntpd daemon is running with root privileges,
    # the drift file directory must have root ownership.
    # Otherwise, the following error message occurs:
    # frequency file /var/lib//ntp/drift.TEMP: Permission denied
    chown root:root ${D}${NTP_USER_HOME}

    # Remove sntp
    rm -f ${D}/etc/default/sntp
}
