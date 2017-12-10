# 本脚本用于进行个体选择

function selection(ncre,npare,x2ro::Array)
    rotmp = Array{Float64}(ncre)
    patmp = Array{Rotor}(npare)
    for i in 1:ncre
        rotmp[i] = x2ro[i].fitness(x2ro[i])
    end
    minpower = minimum(rotmp)
    avepower = mean(rotmp)
    minro = x2ro[indmin(rotmp)]
    for j in 1:npare
        patmp[j] = x2ro[indmin(rotmp)]
        deleteat!(rotmp,indmin(rotmp))
    end

    return patmp,minpower,avepower,minro
end
