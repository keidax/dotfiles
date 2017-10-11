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
}
trap finish QUIT

# Stty settings
#   raw:    raw input, no delay
#   opost:  do output processing (for newlines)
#   isig:   enable control characters
#   susp:   disable Ctrl-Z
#   intr:   disable Ctrl-C
#   quit:   enable Ctrl-\ (just in case)
# The end result is that all input is sent, except Ctrl-\ is used to quit.
"$STTY_PROG" raw opost isig susp "undef" intr "undef" quit '^\'

echo "[TTY captured, quit with Ctrl-\\]"

xxd -i || true
# TODO: figure out how to silence 'Quit: 3' message produced by bash
