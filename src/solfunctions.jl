include(pwd()*"\\src\\const.jl")
include(pwd()*"\\src\\mathfunctions.jl")
include(pwd()*"\\src\\flapreponse.jl")
include(pwd()*"\\src\\uniforminflow.jl")
include(pwd()*"\\src\\aoaget.jl")
include(pwd()*"\\src\\clcdget.jl")
include(pwd()*"\\src\\rotorforce.jl")
include(pwd()*"\\src\\trim_windtu.jl")

function uitest(x2ro::Rotor,judge=false)

    chroot = x2ro.chroot.v
    taper = x2ro.taper.v
    θtw = x2ro.twist.v

    # ---
    ch = Array{Float64}(NR,Nbe) #桨叶弦长
    rb = Array{Float64}(NR,Nbe)  #桨叶叶素点分段径向长度值
    dr = Array{Float64}(NR,Nbe)  #桨叶叶素分段长度值

    for k in 1:NR
      for i in 1:Nbe
        ch[k,i] = chroot*taper*(i-1)/Nbe
        dr[k,i] = R/Nbe
        rb[k,i] = R/Nbe*(i-1)+dr[k,i]/2
      end
    end
    # ---

    ψ = 0.0
    beta_lat = 0.0
    beta_lon = 0.0
    θcp = zeros(Float64,NR)
    θlat = zeros(Float64,NR)
    θlon = zeros(Float64,NR)
    θ0 = Array{Float64}(NR,Nbe)
    for k in 1:NR
      θcp[k] = θ7
      θlat[k] = thelat
      θlon[k] = thelon
      for i in 1:Nbe
        θ0[k,i] = θcp[k]+θtw*(rb[k,i]/R-0.7)
      end
    end
    index = 1
    betanow = βang0
    betaxnow = dβ0
    rot = 0.0
    blat = 0.0
    blon = 0.0
    MQ = 0.0
    uitmp = uniforminflow(ψ,rb,θcp,θlat,θlon,betanow,betaxnow)

    while index<=10*npsi # 如果计算了100圈还没收敛就结束计算
      vind_r = uitmp[1]
      vall_r = uitmp[2]
      beta = uitmp[4]

    #   if index%npsi==0
    #     print("===当前挥舞角$(beta/π*180)°===\n")
    #   end

      dbeta = uitmp[5]
      blat = blat+uitmp[4]*sin(ψ)
      blon = blon+uitmp[4]*cos(ψ)

      # This file is used for get angle-of-attack
      aoatmp = aoaget(vall_r,ψ,θ0,θlat,θlon,beta)
      α_aero = aoatmp[1]
      θ = aoatmp[2]

      # This file is to get the Cl and Cd of Blade Element
      clcdtmp = clcdget(α_aero,vall_r)
      Cl = clcdtmp[1]
      Cd = clcdtmp[2]

      # This file calculate the whole aerodynamic force of the rotor in the hub
      rftmp = rotorforce(ψ,ch,rb,vall_r,α_aero,θ,Cl,Cd)
      rot = rot+rftmp[3]
      MQ = MQ+rftmp[4]
      Mbeta_aero = rftmp[5][1]

      # if index%npsi==0
      #   print("===当前挥舞力矩：$(Mbeta_aero)N·m===\n")
      # end
      # print("$(θ/π*180)\n")
      # print("$(α_aero/π*180)\n")
      # print("\n")

      # The file calculate the uniform induced velocity
      uitmp = uniforminflow(ψ,rb,θcp,θlat,θlon,beta,dbeta,Mbeta_aero)

      ψ = ψ+dψ

      # 此处要输入转过一周进行配平的条件，今天来不及了明天完成，作此标志 12/2/2017
      if index%npsi==0
        rot = rot/npsi

        # print("===当前拉力：$(rot)N===\n")
        # print("===当前旋翼功率：$(-MQ)W===\n")

        beta_lat = blat/npsi
        beta_lon = blon/npsi

        # rot = 0.0
        # blat = 0.0
        # blon = 0.0
        ψ = 0.0

        # 此处开始进行配平
        trimtmp = trimwt(uitmp,ch,rb,rot,beta_lat,beta_lon,θcp,θtw,θlat,θlon)
        if trimtmp[1]

        #   print("配平总距：$(trimtmp[5]*180/π)\n")
        #   print("配平横向变距：$(trimtmp[3]*180/π)\n")
        #   print("配平纵向变距：$(trimtmp[4]*180/π)\n")

          break
        else
          θcp = trimtmp[5]
          θ0 = trimtmp[2]

        #   print("配平总距：$(trimtmp[5]*180/π)\n")

          θlat = trimtmp[3]
          θlon = trimtmp[4]
          rot = 0.0
          blat = 0.0
          blon = 0.0
        end
      end


      index = index+1
    end

    if index==10*npsi
        return abs(MQ*100)
    else
        return -MQ
    end
end
