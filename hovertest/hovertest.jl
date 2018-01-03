# this script is used for testing hover functions

# include(pwd()*"\\src\\const.jl")
# include(pwd()*"\\src\\mathfunctions.jl")
# include(pwd()*"\\src\\aoaget.jl")
# include(pwd()*"\\src\\clcdget.jl")
# include(pwd()*"\\src\\rotorforce.jl")

include(pwd()*"\\gatest\\creatures.jl")
# include(pwd()*"\\src\\hoverfunc.jl")

tic()
# x2ro = initcre()[1]
chroot = Ropara(0.067,0.06,0.07)
taper0  = Ropara(1.0,0.6,1.0)
taperr = Ropara(0.3*R,0.1*R,0.9*R)
twist1 = Ropara(-5./180*π,-20.0/180*π,5.0/180*π)
twist2 = Ropara(-5./180*π,-20.0/180*π,5.0/180*π)
twistr = Ropara(0.5*R,0.1*R,0.8*R)
x2ro = Rotor(chroot,taper0,taperr,twist1,twist2,twistr,fitness)
hovertmp = uitest2hover(x2ro)
print("the result is : $(hovertmp)")
toc()
