# this script is used for testing hover functions

# include(pwd()*"\\src\\const.jl")
# include(pwd()*"\\src\\mathfunctions.jl")
# include(pwd()*"\\src\\aoaget.jl")
# include(pwd()*"\\src\\clcdget.jl")
# include(pwd()*"\\src\\rotorforce.jl")

include(pwd()*"\\gatest\\creatures.jl")
# include(pwd()*"\\src\\hoverfunc.jl")

tic()
x2ro = initcre()[1]
hovertmp = uitest2hover(x2ro)
print("the result is : $(hovertmp)")
toc()
