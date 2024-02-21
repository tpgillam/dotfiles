###########
# General #
###########

# Awesome vi like bash line editing
set -o vi

export EDITOR="nvim"
export VISUAL="nvim"

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
alias vimdiff='nvim -d'

# Do not make my terminal hang if I mistype things, since that happens
# very frequently. By default many modern distros will set this to
# look in the package manager for a package that might provide the
# command.
unset command_not_found_handle

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

  # Add support for julia completion.
  . ~/dotfiles/julia-completions/julia-completion.bash
fi

################
# fuzzy filing #
################

# Use the bash configuration file if it exists.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

fcd() {
    # Note that we use NUL termination everywhere so that we can handle directories
    # whose names end with a space.
    local selected_dir=$(find . -type d 2>/dev/null | fzf) && cd "$selected_dir" || return 1
}

#############
# SSH agent #
#############

# Start ssh-agent if it is not already running
if [ -z "$(pgrep ssh-agent)" ]; then
    eval $(ssh-agent) &> /dev/null
fi

# Add SSH identity
ssh-add -q


######################
# Python development #
######################

# Initialise pyenv if it is available on the path.
command -v pyenv >/dev/null && eval "$(pyenv init -)"

function pycheck() {
    poetry run ruff format "$@"
    poetry run ruff check --fix "$@"
    poetry run pyright "$@"
}


#####################
# Julia development #
#####################

# Allow as many threads as possible by default
export JULIA_NUM_THREADS=auto

# Always look in the current or parent directories for a `Project.toml`
# by default.
export JULIA_PROJECT=@.

# This is required when cross-building for MacOS to indicate to BinaryBuilder.jl
# that I accept Apple's terms.
export BINARYBUILDER_AUTOMATIC_APPLE=true

# Format file(s) with JuliaFormatter.jl
juliaformat() {
    local code='
        using JuliaFormatter
        filenames = if isempty(ARGS)
            split(String(read(`find -type f -name \*.jl`)))
        else
            ARGS
        end
        for filename in filenames
            did_change = !format(filename)
            if did_change
                println("Altered: $filename")
            end
        end'
    julia -e "$code" "$@"
}

# Make a julia project in the current directory.
mkproj() {
    local dirname="`pwd`/$1"
    (
        set -e
        echo "Making $dirname"
        mkdir $dirname
        cd $dirname
        printf 'style = "blue"\n' > .JuliaFormatter.toml  # Add a JuliaFormatter configuration file
        # Create empty Project.toml & Manifest.toml
        touch Project.toml
        julia --startup-file=no --project=. -e 'using Pkg; Pkg.instantiate()'
    )
    cd $dirname
    julia --project=.
}

# The only argument is the name, and it will prepend today's date.
mkdatedproj() {
    mkproj "$(date +'%Y%m%d')_$1"
}

# Make a new Julia package in .dev with my template and switch to it.
# The only argument is the package name.
# NOTE: the "documenter key" that is generated is used by various GitHub actions workflows.
#   It doesn't _have_ to be run now, and re-running the last few lines can be done at a later
#   stage if desired.
mkpackage() {
    julia --startup-file=no --project=$(mktemp -d) -e '
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
dev() {
    # Don't use the startup file as it adds a bit of latency (by importing Revise)
    julia --startup-file=no -e '
        using Pkg
        Pkg.activate(; temp=true)
        pkg = "'$1'"
        if startswith(pkg, "https://") || startswith(pkg, "git@github.com")
            Pkg.develop(url=pkg)
        else
            Pkg.develop(pkg)
        end

        # Get the location of the package that we just got -- activate and instantiate it.
        package_dir = joinpath(Pkg.devdir(), only(keys(Pkg.project().dependencies)))

        Pkg.activate(package_dir)
        Pkg.instantiate()

        # Make vscode use the correct environment.
        vscode_config_file = joinpath(package_dir, ".vscode", "settings.json")
        if !isfile(vscode_config_file)
            mkpath(dirname(vscode_config_file))
            write(vscode_config_file, "\"julia.environmentPath\": $package_dir")
        end

        # Print the package directory so the calling shell knows where it is.
        println("\n\nDeveloped $pkg to $package_dir")'
}

# Build Julia documentation in the current project.
makedocs() {
    julia --startup-file=no --project=docs -e '
        using Pkg
        Pkg.develop(PackageSpec(path=pwd()))
        Pkg.instantiate()
        Pkg.update()
        include("docs/make.jl")'
}

# Run Julia tests for the current package.
# This should work when run from any subdirectory of that package.
runtest() {
    julia $1 --startup-file=no --project=@. -e '
        using Pkg
        Pkg.test()'
}

# Run Julia notebook for the current project
run_notebook() {
    julia --startup-file=no --project=. -e '
        using Pkg
        Pkg.build("IJulia")  # This is needed to pick up new kernels, e.g. if the jupyter version has changed.
        using IJulia
        notebook(; dir=".")'
}

# List the running notebooks via Julia, e.g. to get auth keys
notebook_list() {
    julia --startup-file=no --project=. -e '
        using IJulia
        jupyter = IJulia.find_jupyter_subcommand("")[1]
        run(`$(jupyter) notebook list`)'
}

