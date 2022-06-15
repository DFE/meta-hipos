# This openssh version fails if you use a password.
# Output:
# Feb 12 08:10:21 4080-0-00000 sshd[4615]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=172.29.23.15  user=root
# Feb 12 08:10:26 4080-0-00000 sshd[4615]: Accepted keyboard-interactive/pam for root from 172.29.23.15 port 56338 ssh2
# Feb 12 08:10:26 4080-0-00000 sshd[4615]: fatal: PAM: pam_setcred(): Failure setting user credentials
# See: https://bugzilla.mindrot.org/show_bug.cgi?id=2475
# ------------------------------------------------------------------------------------------
# Login fails with "Write failed: Broken pipe" when all three of these settings are enabled:
# PasswordAuthentication=yes
# ChallengeResponseAuthentication=yes
# PermitEmptyPasswords=yes
# ------------------------------------------------------------------------------------------
# As workaround this sshd_config disables PermitEmptyPasswords

FILESEXTRAPATHS:prepend := "${THISDIR}/openssh:"

