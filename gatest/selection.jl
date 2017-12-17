# 本脚本用于进行个体选择

@everywhere function solfit(ncre::Int,x2ro::Array)
    rotmp = Array{Float64}(ncre)
    for i in 1:ncre
        rotmp[i] = x2ro[i].fitness(x2ro[i])
    end
    return rotmp
end

function selection(npare::Int,rotmp::Array,x2ro::Array)
    patmp = Array{Rotor}(npare)
    minpower = minimum(rotmp)
    avepower = mean(rotmp)
    minro = x2ro[indmin(rotmp)]
    for j in 1:npare
        patmp[j] = x2ro[indmin(rotmp)]
        deleteat!(rotmp,indmin(rotmp))
    end
    return patmp,minpower,avepower,minro
end
