# **README**
# The following is only a subset of what should belong in a bash profile. These are just common sections that are often
# useful


###########
# General #
###########

# Awesome vi like bash line editing
set -o vi

export EDITOR="vim"
export VISUAL="vim"

# Nice shell prompt, and support resizing...

# Show git branch on prompt
function parse_git_branch_and_add_brackets {
git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\[\1\]/'
}

# Define the bash prompt with colours and git branch :-)
export PS1="\[\e[0;32m\]\h:\w\[\e[m\]\[\e[0;31m\]\$(parse_git_branch_and_add_brackets)\[\e[m\]\[\e[0;32m\]> \[\e[m\]"
shopt -s checkwinsize

export HISTFILESIZE=10000
export HISTSIZE=10000

export CLICOLOR=1

# Useful ls aliases. -N disables wrapping of things with inverted commas
alias ls='ls -N --color=auto'
alias ll='ls -N --color=auto -alh'
alias sl='ls -N --color=auto'



##################
# MacOS specific #
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


############################################
# LS colours — `dircolors` must be on path #
############################################

# These are for giving nicer colours to `ls`
# Light
#export LSCOLORS=ExFxCxDxBxegedabagacad
# Dark
export LSCOLORS=GxFxCxDxBxegedabagaced
d=~/.LS_COLORS
test -r $d && eval "$(dircolors $d)"



#####################
# Julia development #
#####################

# Make a julia project in the current directory.
# The only argument is the name, and it will prepend today's date.
mkproj() {
    dirname="`pwd`/$(date +'%Y%m%d')_$1"
    ( set -e
        echo "Making $dirname"
        mkdir $dirname
        cd $dirname
        printf 'style = "blue"\n' > .JuliaFormatter.toml  # Add a JuliaFormatter configuration file
        julia --project=. -e 'using Pkg; Pkg.add("Revise")'
    )
    cd $dirname
    code . --goto Project.toml:1
    julia --project=.
}

# Make a new Julia package in .dev with my template and switch to it.
# The only argument is the package name.
mkpackage() {
    julia --project=$(mktemp -d) -e '
        using Pkg
        Pkg.add("PkgTemplates")
        include(expanduser("~/dotfiles/julia_template/template.jl"))
        tom_template("'$1'")'
}

# Check out a Julia package for development, and switch to it.
# It will do this in the global Julia env, and then immediately remove it from
# the env
dev() {
    ( set -e
        echo "Checking out $1"
        julia --project=$(mktemp -d) -e 'using Pkg; Pkg.develop("'$1'")'
    )
    dirname="$HOME/.julia/dev/$1"
    cd $dirname
    mkdir -p .vscode
    echo '{
    "julia.environmentPath": "'$dirname'"
}' > .vscode/settings.json
    ( set -e
        echo "Instantiating..."
        julia --project=. -e 'using Pkg; Pkg.instantiate()'
    )
    code .
}

# Build Julia documentation in the current project.
makedocs() {
    julia --project=docs -e '
        using Pkg
        Pkg.develop(PackageSpec(path=pwd()))
        Pkg.instantiate()
        include("docs/make.jl")'
}

# Run Julia tests for the current package.
# This should work when run from any subdirectory of that package.
runtest() {
    julia --project=@. -e '
        using Pkg
        Pkg.test()'
}

# Run Julia notebook for the current project
run_notebook() {
    julia --project=. -e '
        using IJulia
        notebook(; dir=".")'
}

# List the running notebooks via Julia, e.g. to get auth keys
notebook_list() {
    julia --project=. -e '
        using IJulia
        jupyter = IJulia.find_jupyter_subcommand("")[1]
        run(`$(jupyter) notebook list`)'
}

