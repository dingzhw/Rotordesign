# To plot the Envolution Curve

using Plots
gr()
# plotgen = 1
for i in 1:100
  sleep(0.2)
  display(histogram(randn(10000)))
end
# powerplot = plot(x=1:ngen,minpower,label="minpower",lw=5)
# plot!(powerplot,avepower,seriestype=:scatter,label="meanpower",title="Envolution Curve",lw=3)

# while plotgen<=ngen
#     plot(x=1:10,plotgen)
#     if plotgen>=2
#         minplot = zeros(Float64,plotgen)
#         aveplot = zeros(Float64,plotgen)
#         for i in 1:plotgen
#             minplot[i] = minpower[i]
#             aveplot[i] = avepower[i]
#         end
#         powerplot = plot(x=1:plotgen,minplot,label="minpower",lw=5)
#         plot!(powerplot,aveplot,seriestype=:scatter,label="meanpower",title="Envolution Scolpe",lw=3)
#     end
#     plotgen += 1
# end
#
# plot(x=1:10,plotgen)
# gui()
