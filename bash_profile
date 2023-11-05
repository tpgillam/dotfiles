# Entries similar to the following should be put into ~/.profile or ~/.bash_profile as required
# Note that this is rather system-dependent, so is NOT automated!

##################
# MacOS example  #
##################

# Add homebrew to path
eval "$(/opt/homebrew/bin/brew shellenv)"

# I would like to use GNU versions of utilities please
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# I would like to use Homebrew's version of python please
export PATH="/opt/homebrew/opt/python3/libexec/bin/:$PATH"

# Rust installation
. "$HOME/.cargo/env"

# VSCode
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"


##################
# source .bashrc #
##################
# After PATH is setup, load bash configuration. This won't happen
# automatically in a login shell if `.profile` or `.bash_profile` exists.
[ -f ~/.bashrc ] && . ~/.bashrc

