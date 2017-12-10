# 本脚本用于运行GA代码

# ---
const npara = 3
const ncre = 100
const npare = Int(ncre/10)
const nchil = ncre-npare
const mutrate = 0.05
const ngen = Int(ncre*npara) # 最高演化代数
# ---

include(pwd()*"\\gatest\\creatures.jl")
include(pwd()*"\\gatest\\crossovermutation.jl")
include(pwd()*"\\gatest\\selection.jl")

tic() # 计算开始时间

gafile = open(pwd()*"\\output\\ga.log","w")
gen = 1
minpower = zeros(Float64,ngen)
avepower = zeros(Float64,ngen)
minro = Array{Rotor}(ngen)
print("===初始化随机旋翼实例===\n")
write(gafile,"===初始化随机旋翼实例===\n")
x2ro = initcre()
while gen<=ngen
    seltmp = selection(ncre,npare,x2ro)
    x2ro_pa = seltmp[1]
    minpower[gen] = seltmp[2]
    avepower[gen] = seltmp[3]
    minro[gen] = seltmp[4]
    x2ro_child = crossover(gen,mutrate,ngen,nchil,x2ro_pa)
    x2ro = append!(x2ro_pa,x2ro_child)

    print("===第$(gen)代进化完成\n")
    print("===当代最小功率为$(minpower[gen]);对应实例参数为$(minro[gen])===\n")
    print("===当代平均功率为$(avepower[gen])===\n\n")
    write(gafile,"===第$(gen)代进化完成\n")
    write(gafile,"===当代最小功率为$(minpower[gen]);对应实例参数为$(minro[gen])===\n")
    write(gafile,"===当代平均功率为$(avepower[gen])===\n\n")

    gen = gen+1
end

close(gafile)

minfile = open(pwd()*"\\output\\minval2.log","w")
meanfile = open(pwd()*"\\output\\meanval2.log","w")
write(minfile,minpower)
write(meanfile,avepower)
close(minfile)
close(meanfile)

toc() # 计算结束时间
