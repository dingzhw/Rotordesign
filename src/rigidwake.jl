# 这是刚性尾迹模型

function rigidwake(λ,filename=pwd()*"\\rigidwake\\RIGIDWAKE.PLT")
  pointfile = open(filename,"w")
  write(pointfile,"  TITLE = 'RIGID WAKE OF ROTOR'\n")
  ktip = 0.88 # Default Tip Vortex ScrollUp Position
  # dt = dψ/Ω
  Nrw = Int64(2.0*π/dψ)
  rwps = Array{Vector}(Nrw,Nb,NR)
  rbp = Array{Float64}(NR,Nb)
  ζ0 = Array{Float64}(Nrw,Nb,NR)
  # Rtip = Array{Float64}(NR)
  for k in 1:NR
    # Rtip[k] = ktip*R
    for j in 1:Nb
      write(pointfile,"  VARIABLES = 'X','Y','Z'\n")
      write(pointfile,"  ZONE I = $(Nrw)\tF = POINT\n")
      rbp[k,j] = ecut+R/Nb*(j-1)
      for i in 1:Nrw
        ψ = (i-1)*dψ
        ψk = ψ+(k-1)*2*π/NR
        ζ0[i,j,k] = -ψ
        rwps[i,j,k] = [rbp[k,j]*cos(ψk)+μ*R*ψk;
                      -rbp[k,j]*sin(ψk);
                      λ*R*ψ]
        write(pointfile,
              "\t$(rwps[i,j,k][1])\t$(rwps[i,j,k][2])\t$(rwps[i,j,k][3])\n")
      end
    end
  end
  close(pointfile)
  return rwps,ζ0
end
