# 本脚本用于交叉父辈的染色体生成子辈

function muterate(gen,mutrate,ngen)
    # 变异率方程；认为变异开始会是一个较高水平；但是会随着种群的增长逐渐降低
    return 0.24*cos(π/ngen*gen)+0.26
end

function crossover(gen,mutrate,ngen,nchil,pare::Array)
    childtmp = Array{Rotor}(nchil)
    k = 1
    # 父辈两两相交生成子辈
    for i in 1:npare
        for j in 1:npare
            if i==j
                continue
            else
                if rand()>=muterate(gen,mutrate,ngen)  # 如果随机数大于变异率则不变异
                    chroot = pare[i].chroot.v+pare[j].chroot.v
                    taper = pare[i].taper.v+pare[j].taper.v
                    twist = pare[i].twist.v+pare[j].twist.v
                    cichroot = Ropara(chroot/2,0.05,0.10)
                    citaper  = Ropara(taper/2,0.6,1.0)
                    citwist  = Ropara(twist/2,-20.0/180*π,-5.0/180*π)
                    childtmp[k] = Rotor(cichroot,citaper,citwist,fitness)
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
