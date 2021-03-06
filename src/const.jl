# This file defines the const varibles

#=
const ρ = 1.225 #空气密度 量纲kg*m^-3
const ν = 1.46e-4 #运动黏性系数 无量纲
const g = 9.8 #重力加速度  量纲kg*m*s^-2
const v_sound = 343.2 #音速 量纲m/s
const NR = 2  #桨叶片数
const Nbe = 10 #旋翼分段数量
const R = 1.7  #旋翼半径 量纲m
const ecut = 0.25 #桨叶根切比例 无量纲
const m_ = 7.8125 #桨叶质量密度 量纲kg/m
const Ω = 73.3  #旋翼转速 量纲rad/s
const αs = -0*π/180.0  #旋翼轴倾角  量纲rad
const Kβ = 0.0  #桨叶根部挥舞弹簧刚度 量纲？？？
const vair = 0.1 # 来流速度 量纲 m/s
const T = 2500 #飞行器重量 (量纲为kg*m*s^-2)
const dpsideg = 10  # 方位角步进长度（量纲为deg）
const βang0 = 0.0/180*π # 挥舞角初值
const dβ0 = 0.0/180*π # 挥舞角速度初值
const θ7 = 2.0/180*π # 旋翼总距
const θtw = -48.0/180*π # 桨叶扭转角
const thelat = -0/180*π # 横向周期变距
const thelon = 0/180*π # 纵向周期变距
const chroot = 0.11 # 桨根弦长
=#

# ---文本读入---
parafile = open("input\\parameters","r")
paralines = readlines(parafile)
close(parafile)
pacons = Array{String}(length(paralines))
for i in 1:length(paralines)
    pacons[i] = split(paralines[i],"<--------->")[2]
end

const ρ = parse(Float64,pacons[1])
const ν = parse(Float64,pacons[2])
const g = parse(Float64,pacons[3])
const v_sound = parse(Float64,pacons[4])
const NR = parse(Int64,pacons[5])
const Nbe = parse(Int64,pacons[6])
const R = parse(Float64,pacons[7])
const ecut = parse(Float64,pacons[8])
const m_ = parse(Float64,pacons[9])
const Ω = parse(Float64,pacons[10])
const αs = parse(Float64,pacons[11])/180*π
const Kβ = parse(Float64,pacons[12])
const vair = parse(Float64,pacons[13])
const T = parse(Float64,pacons[14])
const dpsideg = parse(Float64,pacons[15])
const βang0 = parse(Float64,pacons[16])/180*π
const dβ0 = parse(Float64,pacons[17])
const θ7 = parse(Float64,pacons[18])/180*π
# const θtw = parse(Float64,pacons[19])/180*π
const thelat = parse(Float64,pacons[20])/180*π
const thelon = parse(Float64,pacons[21])/180*π
# const chroot = parse(Float64,pacons[22])
const cbe = parse(Float64,pacons[23])
# ---文本读入完成---

# ---
const taper = 1.0   # 桨叶尖削比
const Iβ = m_/3*R^3(1-ecut^3)  #桨叶挥舞惯量 量纲kg*m^2
const v_air = [vair*cos(αs),0.0,vair*sin(αs)] #forward wind speed  量纲m/s
const μ_air = v_air[1]/(Ω*R)  #来流在桨盘edgewise方向分量  无量纲
const λ_air = v_air[3]/(Ω*R)  #来流在桨盘轴向分量  无量纲
const A = π*R^2 #参考面积 量纲为m^2
const fnonc = ρ*A*Ω*R^2*Ω #力的无量纲化参数 量纲kg*m*s^-2
const mnonc = ρ*A*Ω^2*R^3 #力矩的无量纲化参数 量纲kg*m^2/s^2
const CT = T/fnonc  #无量纲重量系数
const dψ = dpsideg*π/180 #方位角步进步长 (量纲为rad)
const npsi = Int(360/dpsideg) # 周向分割步数
# ---

# ---
# ch = Array{Float64}(NR,Nbe) #桨叶弦长
# rb = Array{Float64}(NR,Nbe)  #桨叶叶素点分段径向长度值
# dr = Array{Float64}(NR,Nbe)  #桨叶叶素分段长度值
#
# for k in 1:NR
#   for i in 1:Nbe
#     # ch[k,i] = chroot*taper*(i-1)/Nbe
#     dr[k,i] = R/Nbe
#     rb[k,i] = R/Nbe*(i-1)+dr[k,i]/2
#   end
# end
# ---

# ---升阻力特性文本读入&插值函数生成---
using Interpolations

function readclcd(filename=pwd()*"\\input\\cx.txt")
    # 读取升阻力特性文档并生成插值函数
    cxlines = open(readlines,filename)
    cdstring = Array{String}(length(cxlines),2)
    for i in 1:length(cxlines)
        for j in 1:2
            cdstring[i,j] = split(cxlines[i],"\t")[j]
        end
    end
    cdf = Array{Float64}(length(cxlines),2)
    for i in 1:length(cxlines)
        cdf[i,1] = parse(Float64,cdstring[i,1])*180-180
        cdf[i,2] = parse(Float64,cdstring[i,2])
    end

    itp = interpolate(cdf,BSpline(Constant()),OnCell())

    return itp
end

# ---阻力特性插值函数生成---
cditp = readclcd(pwd()*"\\input\\cx_77.txt")
dcd = (cditp[length(cditp)/2,1]-cditp[1,1])/(length(cditp)/2-1)
# ---升力特性插值函数生成---
clitp = readclcd(pwd()*"\\input\\cy_77.txt")
dcl = (clitp[length(clitp)/2,1]-clitp[1,1])/(length(clitp)/2-1)

# ---升阻力系数插值函数生成完毕---

# 备注：注意ITP的Length，他的Length是所有元素总和
