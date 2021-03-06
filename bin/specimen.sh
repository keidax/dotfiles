#!/usr/bin/env bash
#
# Outputs a variety of text and symbols in different styles for the current
# font. In typography, this is known as a specimen.

read -r -d '' TEXT <<'EOF'
0123456789 !@#$%%^&*()_+-=    <!-- <-- <- <=> => -> -->
ABCDEFGHIJKLMNOPQRSTUVWXYZ    == != === !== ::Klass::CONST
abcdefghijklmnopqrstuvwxyz    <= =~ >= && &. := ¯\_(ツ)_/¯
¶`~"' ¡! .,:;¿? \|/ {}[]<>
1!Illegal O(0) bdpqijlunmw
ΔΠΣλ‐–— ‘µ’ “Æ” „©‟ ⟦⟧ «ç»    ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏
Here’s the “thing”.           ⸨•⸩ ➜  ✓ ✔ ✕ ✖ ✗ ✘  ⮁ ⭡ ⭣
EOF

# Cycle through normal, italic, bold, and bold italic faces
for effect in 0 3 "0;1" "1;3" ; do
    printf '\e[%sm%s\e[0m\n\n' "$effect" "$TEXT"
done
