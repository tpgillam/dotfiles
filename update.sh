#!/bin/bash 
dir=~/dotfiles                    # dotfiles directory
files=`cat _configfiles`    # list of files/folders to symlink in homedir

for file in $files; do
    echo "Creating symlink to $file in home directory."
    if [ ! -e ~/.$file ] 
    then
        ln -s $dir/$file ~/.$file
      else
        echo "Already exists - skipping"
    fi
done
