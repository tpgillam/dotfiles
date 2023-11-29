import Pkg

let
    # Ensure that all of these packages are installed, and are `using`ed.
    packages = ("Revise", "OhMyREPL")
    for package in packages
        isnothing(Base.find_package(package)) && Pkg.add(package)
        @eval using $(Symbol(package))
    end

    # Don't use rainbow brackets in OhMyREPL, and don't autcomplete.
    OhMyREPL.enable_pass!("RainbowBrackets", false)
    OhMyREPL.enable_autocomplete_brackets(false)
end
