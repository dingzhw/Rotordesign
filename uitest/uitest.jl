# The file test the uniform inflow condition

# include(pwd()*"\\src\\const.jl")
# include(pwd()*"\\src\\mathfunctions.jl")
# include(pwd()*"\\src\\flapreponse.jl")
# include(pwd()*"\\src\\uniforminflow.jl")
# include(pwd()*"\\src\\aoaget.jl")
# include(pwd()*"\\src\\clcdget.jl")
# include(pwd()*"\\src\\rotorforce.jl")
# include(pwd()*"\\src\\trim_windtu.jl")
include(pwd()*"\\gatest\\creatures.jl")

tic() # 程序起始标志
print("===计算初始化===")

x2ro = initcre()[1]
power = uitest(x2ro)

print("===计算收敛===\n")
print("===配平旋翼功率为：$(power)W===\n")
# print("===总计算步数$(index)===\n")
toc() # 程序结束
