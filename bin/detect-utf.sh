#!/bin/bash
#
# Determine if the running terminal properly handles fancy characters. This
# script returns 0 if the terminal considers some UTF-8 text to be the proper
# length. If the text does not appear to be the proper length (which might
# confuse the shell, cause line wrapping problems, etc.), this script returns
# 1.
#
# Inspired by https://stackoverflow.com/a/8353312/910109

compare_columns() {
    # Define our test text (which should be more than simple ASCII characters)
    local text='…λ'
    # Expected length of our test text
    local expected_len=2
    # Define the CSI escape sequence
    local CSI='['
    local ESC='['

    local garbage=
    local initial=
    local final=

    # Ask the terminal to report the cursor position
    echo -en "${CSI}6n"
    # Read in the terminal's response
    # $garbage holds the beginning of the escape sequence
    read -s -r -d "$ESC" garbage
    read -s -r -d "R" initial
    # Output our text, and get the new cursor position
    echo -en "$text"
    echo -en "${CSI}6n"
    read -s -r -d "$ESC" garbage
    read -s -r -d "R" final

    # Clear the line with our sample text, and return cursor to beginning. The
    # text might flash on the screen briefly, but this is better than just
    # leaving it laying around.
    echo -en "${CSI}2K\r"

    # Trim the cursor positions to just the columns
    local initial_col=$(echo -e "\n$initial" | cut -d ';' -f 2)
    local final_col=$(echo "$final" | cut -d ';' -f 2)
    # Calculate the difference between columns (i.e. the length of the text)
    local final_len=$(( final_col - initial_col ))

    # Return 0 if the terminal considers the text to be the expected length
    [ $expected_len = $final_len ]
}

compare_columns
