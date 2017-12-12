# 本脚本用于运行GA代码

addprocs(3)
using Plots
gr()

include(pwd()*"\\gatest\\creatures.jl")
include(pwd()*"\\gatest\\crossovermutation.jl")
include(pwd()*"\\gatest\\selection.jl")

tic() # 计算开始时间
tstart = time()

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
    sel1 = remotecall(selection,1,ncore,ncorepare,x2ro[1:ncore])
    sel2 = remotecall(selection,2,ncore,ncorepare,x2ro[ncore+1:2*ncore])
    sel3 = remotecall(selection,3,ncore,ncorepare,x2ro[2*ncore+1:3*ncore])
    sel4 = remotecall(selection,4,ncore,ncorepare,x2ro[3*ncore+1:4*ncore])
    seltmp1 = fetch(sel1)
    seltmp2 = fetch(sel2)
    seltmp3 = fetch(sel3)
    seltmp4 = fetch(sel4)
    # seltmp = vcat(seltmp1,seltmp2,seltmp3,seltmp4)
    # ---Solution 1 Completed---

    # seltmp = selection(ncre,npare,x2ro)   # 不进行并行计算的方式

    x2ro_pa     =   vcat(seltmp1[1],seltmp2[1],seltmp3[1],seltmp4[1])
    mintmp      =   vcat(seltmp1[2],seltmp2[2],seltmp3[2],seltmp4[2])
    meantmp     =   vcat(seltmp1[3],seltmp2[3],seltmp3[3],seltmp4[3])
    minrotmp    =   vcat(seltmp1[4],seltmp2[4],seltmp3[4],seltmp4[4])
    minpower[gen] = minimum(mintmp)
    avepower[gen] = mean(meantmp)
    minro[gen] = minrotmp[indmin(mintmp)]
    x2ro_child = crossover(gen,mutrate,ngen,nchil,x2ro_pa)
    x2ro = append!(x2ro_pa,x2ro_child)

    print("===第$(gen)代进化完成\n")
    print("===当代最小功率为$(minpower[gen]);对应实例参数为$(minro[gen])===\n")
    print("===当代平均功率为$(avepower[gen])===\n\n")
    write(gafile,"===第$(gen)代进化完成\n")
    write(gafile,"===当代最小功率为$(minpower[gen]);对应实例参数为$(minro[gen])===\n")
    write(gafile,"===当代平均功率为$(avepower[gen])===\n\n")

    # ---输出进化曲线图---
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

    # ---收敛条件---
    if gen<nstallgen||abs(minpower[gen]-minpower[gen-1])>=1e-3||minpower[gen]/avepower[gen]<=0.7
        gen = gen+1
    else
        break
    end

    # gen = gen+1
end

tend = time()
write(gafile,"===本次进化的总时间为：$(tend-tstart)秒===")

close(gafile)

# ---输出最小功率和平均功率的记录文档---
minfile = open(pwd()*"\\output\\minval2.log","w")
meanfile = open(pwd()*"\\output\\meanval2.log","w")
write(minfile,"---Min Power Records---\n")
write(meanfile,"---Mean Power Records---\n")
for i in 1:ngen
    write(minfile,"Gen $(i) : $(minpower[i])\n")
    write(meanfile,"Gen $(i) : $(avepower[i])\n")
end
close(minfile)
close(meanfile)
# ---输出完毕---

toc() # 计算结束时间
