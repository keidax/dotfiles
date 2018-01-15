#!/bin/sh
#
# Print all keystrokes in hex, to decipher exactly what escape sequences your
# terminal is sending. Similar to `showkeys -a`.

# Use /bin/stty to get the native BSD version on Mac
STTY_PROG="/bin/stty"

# Make sure we finish cleanly
tty_state=$("$STTY_PROG" -g)
finish() {
    "$STTY_PROG" "$tty_state"
    printf '\n[TTY restored]\n'
    exit 0
}
trap finish EXIT
# Catch signals so our EXIT trap runs
trap ':' INT TERM QUIT

# Stty settings
#   raw:    raw input, no delay
#   opost:  do output processing (for newlines)
#   echo:   echo input
#   echoctl:    echo control characters as e.g. '^D'
#   isig:   enable control characters
#   susp:   disable
#   intr:   enable as Ctrl-\
#   quit:   disable
# The end result is that all input is sent, except Ctrl-\ is used to quit.
"$STTY_PROG" raw opost 'echo' echoctl isig susp 'undef' intr '^\' quit 'undef'

echo "[TTY captured, quit with Ctrl-\\]"

hexdump -v -e '"\t" /1 " %3d"' -e '/1 " 0x%02x"' -e '" = %-3_u\n"'
