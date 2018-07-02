#!/usr/bin/env bash

if tmux_is_at_least 2.4; then
    prefix_format="#{?client_prefix,#[fg=colour4]#[bold]C-Spc\
#{?#{==:#{client_key_table},window},+n\
,#{?#{==:#{client_key_table},fullwindow},+n+w,}}\
#[fg=colour7]#[nobold]\
,     }"
else
    prefix_format="#{?client_prefix,#[fg=colour4]#[bold]C-Spc,     }"
fi

tmux set -g status-left "#[bg=colour20,fg=colour18]⟦#S⟧#[bg=colour8] \
#(internet-info) #(battery-info) #[bg=colour19] \
${prefix_format}"
