#  VS Code workaround: https://github.com/julia-vscode/julia-vscode/issues/800
if isdefined(@__MODULE__, :LanguageServer)
    @info "Using VS Code workaround..."
    include("../src/MicrotubuleSpringModel.jl")
    using .MicrotubuleSpringModel
else
    using MicrotubuleSpringModel
end

using Quaternions
using Quaternions: Quaternion



conf = from_toml(MicrotubuleSpringModel.RotationConfig, "config/rotation.toml")

conf = set_bond_angles(conf)

beads, bead_info, dirs = MicrotubuleSpringModel.initialise_dimer(conf)

Nt = 100
step = 1
time = 0:step:Nt
E = zeros((6,Nt÷step+1))

E[:,1] = total_energy(beads, bead_info, dirs, conf.spring_consts)
@showprogress for i in 1:Nt
    iterate!(beads, bead_info, dirs, conf, conf.iter_pars)
    if i % step == 0
        E[:,i÷step+1] = total_energy(beads, bead_info, dirs, conf.spring_consts)
    end
end

F = zeros(Float64, (3, lastindex(beads)))
torque = similar(F)
MicrotubuleSpringModel.eval_forces_and_torques!(F, torque, beads, bead_info, dirs, conf.spring_consts)

GLMakie.activate!()
GLMakie.closeall()
scene = plot(beads, bead_info, dirs)
scene



labels = [L"E_{long}^r", L"E_{in}^r", L"E_{long}^\theta", L"E_{in}^\theta"]

indices = [2,3,5,6]
E_tot = vec(sum(E,dims=1))
idx = argmin(E_tot)
CairoMakie.activate!()
f = Figure(resolution=(1000,600))
ax = Axis(f[1,1], xlabel="Iteration number", ylabel="Total Energy")
lines!(ax,time, E_tot,color=:black, linewidth=4, label=L"E_T")
series!(ax,time,E[indices,:], color=[MicrotubuleSpringModel.NATURE.colors...,:red],linewidth=4, labels=labels)
vlines!(ax, time[idx], 0.0,25)
xlims!(0,Nt)
ylims!(low=0.0)
axislegend(ax, position=:rt)
f