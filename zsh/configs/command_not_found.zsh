# Add custom behavior on missing commands
command_not_found_handler() {
    # For a command starting with n.times, run the rest of the command n times
    # (Inspired by Ruby syntax)
    if [[ $0 =~ "^([[:digit:]]+).times$" ]]; then
        shift
        for i in $(seq 1 $match); do
            # Use q modifier to prevent reevaluation of special strings
            ( eval ${(q)@} )
        done
    else
        echo "handler: command not found: $0" 1>&2
        return 127
    fi
}
