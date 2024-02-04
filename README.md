I am Tom's configuration files!

# Installation

## Dependencies

The following should be installed before starting:

- git
- dircolors
- tmux
- neovim
- ripgrep

### Suggested dependencies

Other tools that might be useful:
- tree
- Rust via [rustup](https://rustup.rs/)
- Julia via [juliaup](https://github.com/JuliaLang/juliaup)
- Python via [pyenv](https://github.com/pyenv/pyenv) and [poetry](https://python-poetry.org/docs/#installing-with-the-official-installer)

## Configuration files

Run `./install`. This will install most configuration (idempotently) with some exceptions:

### `bash_profile`
The purpose of this file is to set `PATH` and other environment variables that are system specific, and/or are not idempotently updated.

Some subset of the contents of this file should be adapted into `~/.bash_profile` or `~/.profile`,
depending on how your system is configured.

Note that all other idempotent shell configuration (e.g. functions, aliases, prompt) are stored in `~/.bashrc`.
This file is designed to be portable.

## Optional setup

### Rust + vim integration
Need to install [rustup](https://rustup.rs/), and then `rust-analyzer` with:
```
rustup component add rust-analyzer
```

### Python + vim integration
For a sensible experience, work in a python virtual environment managed e.g. by poetry.
The environment _must_ be activated before starting neovim, otherwise pyright will complain about missing imports.

Ruff 'fix all' is registered as a code action (so do `<leader>a` in the desired buffer and follow instructions).
