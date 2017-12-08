# 本脚本用于生成旋翼实例

# include(pwd()*"\\uitest\\uitest.jl")

# ---
const ncre = 100
const npare = ncre/10
const nchil = ncre-npare
const mutrate = 0.02
# ---

type Ropara # 旋翼参数类型
    v::Float64
    min::Float64
    max::Float64

    Ropara(v,min,max) = new(min+(max-min)*rand(),min,max)
end

type Rotor # 旋翼实例类型
    chroot::Ropara  # 桨根弦长
    taper::Ropara   # 桨叶尖削
    twist::Ropara   # 桨叶扭转角
    fitness         # 适应函数
end

# 适应函数--->配平后返回旋翼总功率
function fitness(ro::Rotor)

    return true
end

# 约束函数--->满足约束条件返回true，否则返回false
function constraint(ro::Rotor)

    return true
end

# 实例初始化--->初始化包含不同参数的一系列旋翼实例
function initcre()
    x2ro = Array{Rotor}(ncre)
    icre = 1
    while true
        chroot = Ropara(0.0,0.05,0.10)
        taper  = Ropara(0.0,0.6,1.0)
        twist  = Ropara(0.0,-20.0,-5.0)
        x2ro[icre] = Rotor(chroot,taper,twist,fitness)
        if constraint(x2ro[icre])
            icre = icre+1
        end
        if icre>ncre
            break
        end
    end

    return x2ro
end
