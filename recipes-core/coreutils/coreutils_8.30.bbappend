
# Make hostname's priority lower than busybox, because busybox hostname
# supports option -F. And legacy scripts use this option.
ALTERNATIVE_PRIORITY[hostname] = "20"
