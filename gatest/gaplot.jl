# To plot the Envolution Curve

using Plots
gr()

powerplot = plot(x=1:ngen,minpower,label="minpower",lw=5)
plot!(powerplot,avepower,seriestype=:scatter,label="meanpower",title="Envolution Curve",lw=3)
