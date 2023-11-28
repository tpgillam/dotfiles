import Pkg

let
    # Ensure that all of these packages are installed, and are `using`ed.
    packages = ("Revise",)
    for package in packages
        isnothing(Base.find_package(package)) && Pkg.add(package)
        @eval using $(Symbol(package))
    end
end
