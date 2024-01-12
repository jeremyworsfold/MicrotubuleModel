using Logging
using FilePaths; using FilePathsBase: /
using Parameters: @unpack
using ProgressMeter
using CairoMakie
using LaTeXStrings

using StaticArrays
using LinearAlgebra
using LinearAlgebra: normalize, norm
using Distributions
using Colors
using GLMakie
using Configurations
using Setfield

using Quaternions
using Quaternions: Quaternion

#  VS Code workaround: https://github.com/julia-vscode/julia-vscode/issues/800
if isdefined(@__MODULE__, :LanguageServer)
    @info "Using VS Code workaround..."
    include("src/MicrotubuleSpringModel.jl")
    using .MicrotubuleSpringModel
else
    using MicrotubuleSpringModel
end

using ColorSchemes
theme = include("scripts/theme.jl")
theme isa Attributes && set_theme!(theme)


Nt = 100_000
stp = 200
filename = "test5.csv"
path = "results/raw"

conf = from_toml(MicrotubuleSpringModel.RotationConfig, "config/stochastic.toml")
conf = set_bond_angles(conf)
beads, bead_info = MicrotubuleSpringModel.initialise(conf)

data = Matrix{Float64}(zeros(Float64, (length(beads.x)*3,1)))
for i in 1:lastindex(beads.x)
    data[3*(i-1)+1:3*i,1] .= beads.x[i]
end
open(path*"/"*filename, "w") do io
    writedlm(io, data', ',')
end

@showprogress for i in 1:Nt
    iterate!(beads, bead_info, conf, conf.iter_pars)
    if i % stp == 0
        MicrotubuleSpringModel.append_to_csv(filename, beads.x)
    end
end
