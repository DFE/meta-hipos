#!/usr/bin/env python3
#
# Copyright (C) 2016-2023 DResearch Fahrzeugelektronik GmbH
#

""" Himx only:
    Compare mac address and lanspeed parameters in file created from board controller info with the
    one in the uboot environment (which is on SD card and thus may be transferred from one device
    to another one).

    The one in uboot environment is modified, if necessary.

    Is supposed to run when booting _after_ the file on HD has been updated with the info from the
    board controller.
"""

import subprocess
import sys
import re


OK_CODE = 0
ERROR_CODE = 1


def main():
    """ Main function """
    devidfile = "/etc/hydraip-devid"
    devidcontent = read_file(devidfile)
    machine = subprocess.check_output("/usr/sbin/hip-machinfo -a", shell=True).decode("utf-8").strip()
    fw_opt = "-c /etc/fw_env-ipcam.config" if machine in ("himx0294-ipcam", "himx0294-impec") else ""
    ubootcontent = subprocess.check_output(f"fw_printenv {fw_opt}", shell=True).decode("utf-8")

    parameters = ["ethaddr", "lanspeed"]

    for param in parameters:
        devidvalue = re.search(f"^{param}=(.+)$", devidcontent, flags=re.MULTILINE)
        if devidvalue:
            # force lower case of all letters to avoid detecting ab:cd... as different from AB:CD...
            devidvalue = devidvalue.group(1).lower()
            ubootvalue = re.search(f"^{param}=(.+)$", ubootcontent, flags=re.MULTILINE)
            if ubootvalue:
                ubootvalue = ubootvalue.group(1).lower()
            if devidvalue != ubootvalue:
                print(f"Update u-boot env: {param} {devidvalue}")
                subprocess.check_output(f"fw_setenv {fw_opt} {param} {devidvalue}", shell=True)


def read_file(file):
    """ Read the content of a file.

        Exit program with ERROR_CODE, if an error was encountered.
        Return content, otherwise

        :param file: file to be displayed
        :returns: the content of the file
    """
    try:
        with open(file, encoding="utf-8") as fhd:
            return fhd.read().rstrip()
    except IOError:
        sys.exit(OK_CODE)


if __name__ == '__main__': # pragma: no cover
    main()
