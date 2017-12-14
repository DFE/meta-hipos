#!/usr/bin/env python

""" Himx only:
    Compare mac address and lanspeed parameters in file created from board controller info with the one in the uboot
    environment (which is on SD card and thus may be transferred from one device to another one).

    The one in uboot environment is modified, if necessary.

    Is supposed to run when booting _after_ the file on HD has been updated with the info from the board controller.
"""

import subprocess
import sys
import re


OK_CODE = 0
ERROR_CODE = 1


def main():
    devidfile = "/etc/hydraip-devid"
    devidcontent = read_file(devidfile)
    machine = subprocess.check_output("/usr/sbin/hip-machinfo -a", shell=True).strip()
    fw_opt = "-c /etc/fw_env-ipcam.config" if machine == "himx0294-ipcam" else ""
    ubootcontent = subprocess.check_output("fw_printenv {}".format(fw_opt), shell=True)

    parameters = [ "ethaddr", "lanspeed" ]

    for p in parameters:
        devidvalue = re.search(r'^{}=(.+)$'.format(p), devidcontent, flags=re.MULTILINE)
        if devidvalue:
            # force lower case of all letters to avoid detecting ab:cd... as different from AB:CD...
            devidvalue = devidvalue.group(1).lower()
            ubootvalue = re.search(r'^{}=(.+)$'.format(p), ubootcontent, flags=re.MULTILINE)
            if ubootvalue:
                ubootvalue = ubootvalue.group(1).lower()
            if devidvalue != ubootvalue:
                print "Update u-boot env: {} {}".format(p, devidvalue)
                subprocess.check_output("fw_setenv {} {} {}".format(fw_opt, p, devidvalue), shell=True)


def read_file(file):
    """ Read the content of a file.

        Exit program with ERROR_CODE, if an error was encountered.
        Return content, otherwise

        :param file: file to be displayed
        :returns: the content of the file
    """
    try:
        with open(file) as f:
            return f.read().rstrip()
    except IOError as e:
        sys.exit(OK_CODE)


if __name__ == '__main__': # pragma: no cover
    main()
