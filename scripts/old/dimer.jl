#  VS Code workaround: https://github.com/julia-vscode/julia-vscode/issues/800
if isdefined(@__MODULE__, :LanguageServer)
    @info "Using VS Code workaround..."
    include("../src/MicrotubuleSpringModel.jl")
    using .MicrotubuleSpringModel
else
    using MicrotubuleSpringModel
end

conf = from_toml(MicrotubuleConfig, "config/stochastic.toml")

conf = set_bond_angles(conf)

beads, bead_info = initialise_dimer(conf)

conf_burnin = deepcopy(conf)
conf_burnin = @set conf_burnin.external_force = MicrotubuleSpringModel.NoExternalForce()

for i in 1:50000
    iterate!(beads, bead_info, conf_burnin, conf_burnin.iter_pars)
end

GLMakie.activate!()
GLMakie.closeall()
scene = plot(beads, bead_info)
scene



for i in 1:10000
    iterate!(beads, bead_info, conf, conf.iter_pars)
end

l = mt_length(beads)

strain = (l - L0) / L0
stress / strain

microtubule_length(beads) = norm(beads.x[1]-beads.x[end])