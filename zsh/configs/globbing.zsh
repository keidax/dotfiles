# Treat #, ^, and ~ as part of glob patterns
setopt extended_glob

# * doesn't match dotfiles
setopt no_glob_dots

# Raise an error on empty glob
setopt nomatch

# Match numeric filenames numerically
setopt numeric_glob_sort
