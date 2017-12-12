# 本脚本用于运行GA代码

using Plots
gr()

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
    # ---Parallel Computating Solution 1---

    # ---Solution 1 Completed---
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

    if gen>=2
        minplot = zeros(Float64,gen)
        aveplot = zeros(Float64,gen)
        for i in 1:gen
            minplot[i] = minpower[i]
            aveplot[i] = avepower[i]
        end
        powerplot = plot(x=1:gen,minplot,label="minpower",lw=5)
        plot!(powerplot,aveplot,seriestype=:scatter,label="meanpower",title="Envolution Scolpe",lw=3)
    end

    gen = gen+1
end

close(gafile)

minfile = open(pwd()*"\\output\\minval2.log","w")
meanfile = open(pwd()*"\\output\\meanval2.log","w")
# write(minfile,minpower)
# write(meanfile,avepower)
close(minfile)
close(meanfile)

toc() # 计算结束时间
