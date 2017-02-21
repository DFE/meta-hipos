# This openssh version fails if you use a password.
# Output:
# Feb 12 08:10:21 4080-0-00000 sshd[4615]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=172.29.23.15  user=root
# Feb 12 08:10:26 4080-0-00000 sshd[4615]: Accepted keyboard-interactive/pam for root from 172.29.23.15 port 56338 ssh2
# Feb 12 08:10:26 4080-0-00000 sshd[4615]: fatal: PAM: pam_setcred(): Failure setting user credentials

DEFAULT_PREFERENCE = "-1"

