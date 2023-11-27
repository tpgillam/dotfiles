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
alias ll='ls -alh'
alias sl='ls'
alias grep='grep --color=auto'

# Use Neovim instead of vim
alias vim='nvim'


#########################################
# LS colours — if `dircolors` available #
#########################################

if [ -x $(which dircolors) ]; then
    # These are for giving nicer colours to `ls`
    d=~/.LS_COLORS
    test -r $d && eval "$(dircolors $d)"
fi


###################
# bash completion #
###################

# Enable bash completion on a variety of platforms, if it is installed.
# On MacOS this would be done via homebrew
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [ -f /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
      . /opt/homebrew/etc/profile.d/bash_completion.sh
  fi
fi

#####################
# Julia development #
#####################

# Make a julia project in the current directory.
mkproj() {
    set -e
    dirname="`pwd`/$1"
    (
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

# The only argument is the name, and it will prepend today's date.
mkdatedproj() {
    mkproj "$(date +'%Y%m%d')_$1"
}

# Make a new Julia package in .dev with my template and switch to it.
# The only argument is the package name.
mkpackage() {
    julia --project=$(mktemp -d) -e '
        using Pkg
        Pkg.add("PkgTemplates")
        include(expanduser("~/dotfiles/julia_template/template.jl"))
        tom_template("'$1'")
        println()
        println("Generating documentation key...")
        Pkg.add("DocumenterTools")
        using DocumenterTools
        DocumenterTools.genkeys(; user="tpgillam", repo="'$1'.jl")'
}

# Check out a Julia package for development, and switch to it.
# It will do this in the global Julia env, and then immediately remove it from
# the env
dev() {
    set -e
    (
        echo "Checking out $1"
        julia --project=$(mktemp -d) -e 'using Pkg; Pkg.develop("'$1'")'
    )
    dirname="$HOME/.julia/dev/$1"
    cd $dirname
    mkdir -p .vscode
    echo '{
    "julia.environmentPath": "'$dirname'"
}' > .vscode/settings.json
    (
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
        Pkg.update()
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
        using Pkg
        Pkg.build("IJulia")  # This is needed to pick up new kernels, e.g. if the jupyter version has changed.
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


