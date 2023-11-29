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
    dirname="`pwd`/$1"
    (
        set -e
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
dev() {(
    set -e
    echo "Checking out $1"
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

        # Flush to ensure that progress-bars that are written to stdout when cloning packages 
        # are all gone.
        flush(stdout)

        # Print the package directory so the calling shell knows where it is.
        println("\n\nDeveloped $pkg to $package_dir")'
)}

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
    julia --startup-file=no --project=@. -e '
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


