function template(dir::String=pwd())
    @eval begin
        using PkgTemplates
        Template(;
            user="tpgillam",
            dir=$(dir),
            julia=v"1.5",
            plugins=[
                License(; name="MIT"),
                Git(; branch="main", ssh=true),
                GitHubActions(;),
                Codecov(),
                Documenter{GitHubActions}(),
                BlueStyleBadge()
            ]
        )
    end
end
