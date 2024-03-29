using PkgTemplates

# TODO: All of this should really be replaced by something central in PkgTemplates.jl

# Apparently we can only ever use ONE of any particular plugin. This is most vexing.

# For plugin development, need access to internal functions.
using PkgTemplates: @plugin, @with_kw_noshow, Plugin
using PkgTemplates: combined_view, gen_file, render_file, tags

# FIXME: This function is a bit of a hack
function default_file(path...)
    return expanduser(joinpath("~", "dotfiles", "julia_template", path...))
end

# TODO: This would be nicer if templated on the CI plugin type, but then I can't use
# @plugin, and I'm lazy.
@plugin struct JuliaFormatterGitHubActions <: Plugin
    julia_formatter_yml::String = default_file("julia_formatter.yml")
end

function PkgTemplates.hook(p::JuliaFormatterGitHubActions, t::Template, pkg_dir::AbstractString)
    # Copy over the workflow file.
    outdir = joinpath(pkg_dir, ".github", "workflows")
    mkpath(outdir)
    cp(p.julia_formatter_yml, joinpath(outdir, "julia_formatter.yml"))
end


# Here begins stuff that is more reasonable to be customising myself.

function tom_template(package_name::AbstractString; kwargs...)
    x = tom_template(; kwargs...)(package_name)
    @info("""
        Created $package_name — please now add a Documenter key!
        See: https://juliadocs.github.io/Documenter.jl/stable/man/hosting/#Authentication:-SSH-Deploy-Keys
    """)
    return x
end

function tom_template(; dir::Union{Nothing,String}=nothing, julia=v"1.6")
    dir_arg = isnothing(dir) ? () : (; dir)
    Template(;
        user="tpgillam",
        dir_arg...,
        julia,
        authors="Tom Gillam <tpgillam@googlemail.com>",
        plugins=[
            License(; name="MIT"),
            ProjectFile(; version=v"0.1.0"),
            # Possibly controversially, I think including docs/Manifest.toml is a bad idea
            # - Version constraints should be managed, where necessary, by docs/Project.toml
            # - This avoids commit noise after building documentation locally. 
            Git(;
                branch="main", ssh=true, ignore=[".DS_Store", "/docs/Manifest.toml"],
            ),
            Dependabot(),
            Codecov(),
            TagBot(),
            CompatHelper(),
            Documenter{GitHubActions}(;
                makedocs_kwargs=Dict(:checkdocs => :exports)
            ),
            BlueStyleBadge(),
            ColPracBadge(),
            GitHubActions(),  # CI
            Formatter(; style="blue"),
            JuliaFormatterGitHubActions(), # FIXME: this is the nasty one.
        ]
    )
end
