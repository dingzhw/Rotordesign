# 本脚本用于生成旋翼实例

# ---
const npara = 6
const ncre = 64
const npare = Int(ncre/8)
const nchil = ncre-npare
const mutrate = 0.05
const ngen = Int(ncre*npara) # 最高进化代数
const nstallgen = Int(npara*npare)  # 最低进化代数
const ncore = Int(ncre/4) # 每个核心所需计算的个体数量
const ncorepare = Int(npare/4) # 每个核心所需计算的父辈的数量
# ---

@everywhere type Ropara # 旋翼参数类型
    v::Float64
    min::Float64
    max::Float64

    Ropara(v,min,max) = v==0.0 ? new(min+(max-min)*rand(),min,max) : new(v,min,max)
end

@everywhere type Rotor # 旋翼实例类型
    chroot::Ropara      # 桨根弦长
    taper::Ropara       # 桨叶尖削
    taperr::Ropara      # 尖削起始位置
    twist1::Ropara      # 桨叶根段扭度
    twist2::Ropara      # 桨叶尖段扭度
    twistr::Ropara      # 扭转分割点
    fitness::Function   # 适应函数
end

# include(pwd()*"\\uitest\\uitest.jl")
@everywhere include(pwd()*"\\src\\solfunctions.jl")

# 适应函数--->配平后返回旋翼总功率
@everywhere function fitness(ro::Rotor)
    uitmp = uitest(ro)
    return uitmp
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
        taperr = Ropara(0.0,0.1*R,0.9*R)
        twist1 = Ropara(0.0,-20.0/180*π,5.0/180*π)
        twist2 = Ropara(0.0,-20.0/180*π,5.0/180*π)
        twistr = Ropara(0.0,0.1*R,0.8*R)
        x2ro[icre] = Rotor(chroot,taper,taperr,twist1,twist2,twistr,fitness)
        if constraint(x2ro[icre])
            icre = icre+1
        end
        if icre>ncre
            break
        end
    end

    return x2ro
end
