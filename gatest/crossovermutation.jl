# 本脚本用于交叉父辈的染色体生成子辈

function crossover(nchil,pare::Array)
    childtmp = Array{Rotor}(nchil)
    k = 1
    # 父辈两两相交生成子辈
    for i in 1:npare
        for j in 1:npare
            if i==j
                continue
            else
                if rand()>=mutrate  # 如果随机数大于变异率则不变异
                    childtmp[k] = Rotor(pare[i].chroot,pare[j].taper,
                                        pare[i].twist,fitness)
                else                # 否则随机变异
                    chroot = Ropara(0.0,0.05,0.10)
                    taper  = Ropara(0.0,0.6,1.0)
                    twist  = Ropara(0.0,-20.0,-5.0)
                    childtmp[k] = Rotor(chroot,taper,twist,fitness)
                end
                while true  # 判断子辈是否满足约束条件，不满足则变异直到满足
                    if !constraint(childtmp[k])
                        chroot = Ropara(0.0,0.05,0.10)
                        taper  = Ropara(0.0,0.6,1.0)
                        twist  = Ropara(0.0,-20.0,-5.0)
                        childtmp[k] = Rotor(chroot,taper,twist,fitness)
                    else
                        break
                    end
                end
                k = k+1
            end
        end
    end

    return childtmp
end
