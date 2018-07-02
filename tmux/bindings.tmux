#!/usr/bin/env bash

# Binding tweaks for copy mode
if tmux_is_at_least 2.4; then
    tmux bind-key -T copy-mode-vi v send -X begin-selection
    tmux bind-key -T copy-mode-vi Space send -X halfpage-down
else
    tmux bind-key -t vi-copy v begin-selection
    tmux bind-key -t vi-copy Space halfpage-down
fi

# Incremental search for copy-mode-vi
if tmux_is_at_least 2.4; then
    tmux bind-key -T copy-mode-vi / command-prompt -i -I "#{pane_search_string}" -p "/" "send -X search-forward-incremental \"%%%\""
    tmux bind-key -T copy-mode-vi ? command-prompt -i -I "#{pane_search_string}" -p "?" "send -X search-backward-incremental \"%%%\""
fi
