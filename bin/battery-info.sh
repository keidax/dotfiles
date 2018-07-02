#!/usr/bin/env bash

# Inspired by
# https://github.com/jldeen/bad-ass-terminal/blob/master/bin/battery.sh

# BATT='🔋'
# PLUG='🔌'
BATT='⌁'
PLUG='+'

if [[ "$OS" = "Darwin" ]]; then
    battery_info="$(pmset -g batt)"
    # Note the literal tab
    current_charge="$(sed -n -e 's/.*	\([0-9]\{1,3\}\)%.*/\1/p' <<< "$battery_info")"

    if [[ "$battery_info" =~ "Now drawing from 'Battery Power'" ]]; then
        batt_symbol=$BATT
    else
        batt_symbol=$PLUG
    fi
elif [ "$OS" = "Linux" ]; then
    if command_exists upower; then
        battery_path="$(upower --enumerate | grep "BAT")"
        battery_info="$(upower --show-info "$battery_path")"
        current_charge="$(awk '/percentage:/ {print $2}' <<< "$battery_info" | tr -d '%')"

        battery_state="$(awk '/state:/ {print $2}' <<< "$battery_info")"
        if [[ "$battery_state" =~ "discharging" ]]; then
            batt_symbol=$BATT
        else
            batt_symbol=$PLUG
        fi
    elif [ "$DISTRO" = "Raspbian" ]; then
        # Raspberry Pi doesn't support the usual BAT0 interface
        batt_symbol=$PLUG
        current_charge='100'
    fi
fi

if [[ "$current_charge" -lt 20 ]]; then
    color='colour01'
elif [[ "$current_charge" -lt 40 ]]; then
    color='colour16'
elif [[ "$current_charge" -lt 60 ]]; then
    color='colour03'
elif [[ "$current_charge" -lt 80 ]]; then
    color='colour02'
else
    color='colour06'
fi

if [[ -n "$batt_symbol" && -n "$color" && -n "$current_charge" ]]; then
    printf "%s#[fg=%s]%s%%" "$batt_symbol" "$color" "$current_charge"
else
    printf "#[fg=colour16]??%%"
fi
