# This will leave Pkg hanging... but that's OK for most of the time.
import Pkg

let
    # Ensure that all of these packages are installed, and are `using`ed.
    packages = ("BenchmarkTools", "OhMyREPL", "Revise")
    for package in packages
        if isnothing(Base.find_package(package)) 
            # Note that we want to install in the context of the _global_ project,
            # so switch to it now. We don't do it unless installing since most of
            # the time we won't be in this branch, so want to avoid unnecessary
            # work in the more common case.
            project_path = Pkg.project().path
            Pkg.activate()  # Switch to global project specified by LOAD_PATH
            Pkg.add(package)
            Pkg.activate(project_path)
        end
        @eval using $(Symbol(package))
    end

    # Don't use rainbow brackets in OhMyREPL, and don't autcomplete.
    OhMyREPL.enable_pass!("RainbowBrackets", false)
    OhMyREPL.enable_autocomplete_brackets(false)
end
