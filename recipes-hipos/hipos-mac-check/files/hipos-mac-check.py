#!/usr/bin/python

""" Compare mac address in file created from board controller info with the one on the SD card.
    The one on SD card is modified, if necessary.

    Is supposed to run when booting _after_ the file on HD has been updated with the info from
    the board controller.
"""

import subprocess
import sys
import re


OK_CODE = 0
ERROR_CODE = 1


def main():
    hdfile = "/etc/hydraip-devid"
    hdcontent = read_file(hdfile)
    hdmac = re.search(r'^ethaddr=(.+)$', hdcontent, flags=re.MULTILINE)
    if hdmac:
        # capitalize all letters to avoid detecting ab:cd... as different from AB:CD...
        hdmac = hdmac.group(1).upper()
    else:
        sys.exit(OK_CODE)

    ubootcontent = subprocess.check_output("fw_printenv", shell=True)
    ubootmac = re.search(r'^ethaddr=(.+)$', ubootcontent, flags=re.MULTILINE)
    if ubootmac:
        ubootmac = ubootmac.group(1).upper()

    if hdmac != ubootmac:
        subprocess.check_output("fw_setenv ethaddr {}".format(hdmac), shell=True)

    sys.exit(OK_CODE)


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
