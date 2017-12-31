#!/bin/sh
#
# Print all keystrokes in hex, to decipher exactly what escape sequences your
# terminal is sending.

# Use /bin/stty to get the native BSD version on Mac
STTY_PROG="/bin/stty"

# Make sure we finish cleanly
tty_state=$("$STTY_PROG" -g)
finish() {
    "$STTY_PROG" "$tty_state"
    echo "[TTY restored]"
    exit 0
}
trap finish EXIT
# Catch signals so our EXIT trap runs
trap ':' INT TERM QUIT

# Stty settings
#   raw:    raw input, no delay
#   opost:  do output processing (for newlines)
#   -echo:  make sure input is not echoed
#   isig:   enable control characters
#   susp:   disable
#   intr:   enable as Ctrl-\
#   quit:   disable
# The end result is that all input is sent, except Ctrl-\ is used to quit.
"$STTY_PROG" raw opost -echo isig susp "undef" intr '^\' quit 'undef'

echo "[TTY captured, quit with Ctrl-\\]"

hexdump -v -e '/1 "%4_ad# 0x%x"' -e '/1 " = %3_u\n"'
