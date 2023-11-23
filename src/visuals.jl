
ColorSchemes.colorschemes[:nature] = ColorScheme([colorant"#E64B35",colorant"#4DBBD5",colorant"#00A087",colorant"#3C5488", colorant"#F39B7F", colorant"#8491B4", colorant"#91D1C2"])

NATURE = ColorScheme([colorant"#E64B35",colorant"#4DBBD5",colorant"#00A087",colorant"#3C5488", colorant"#F39B7F", colorant"#8491B4", colorant"#91D1C2"])

COLORS = Dict(
    (true, false) => NATURE.colors[1], 
    (false, false) => NATURE.colors[2],
    (true, true) => NATURE.colors[3],
    (false, true) => NATURE.colors[4]
)

function GLMakie.plot(lattice::Vector{Bead}; a=4.05)
    scene = Scene(resolution=(1200,900), backgroundcolor=colorant"#111111")
    cam3d!(scene)
    plot!(scene, lattice; a=a)
    return scene
end

function GLMakie.plot(lattice::Vector{Bead}, dirs; a=4.05, l=4.0)
    @info "here"
    scene = Scene(resolution=(1200,900), backgroundcolor=colorant"#111111")
    cam3d!(scene)
    plot!(scene, lattice, dirs; a=a, l=l)
    return scene
end


function GLMakie.plot!(scene, lattice::Vector{Bead}; a=4.05)
    s = Scene(scene, camera=scene.camera)

    for b in lattice
        mesh!(s, Sphere(Point3f(b.x), a/4), color=COLORS[(b.α, b.kinesin)], shininess=32.0)
    end

    GLMakie.scale!(scene, 0.05, 0.05, 0.05)
    center!(scene)
    return scene
end

function GLMakie.plot!(scene, lattice::Vector{Bead}, dirs; a=4.05, l=4.0)
    s = Scene(scene, camera=scene.camera)

    for b in lattice
        vecs_ = [MicrotubuleSpringModel.transform_orientation(v,b.q) for v in eachcol(dirs[b.α])]
        vs = Vector{Vec{3, Float32}}([l*normalize([imag_part(v)...]) for v in vecs_])
        arrs = arrows!(scene, repeat([Point3f(b.x)],4), vs, linewidth=0.1, color=:white)
    end

    for b in lattice
        mesh!(s, Sphere(Point3f(b.x), a/4), color=COLORS[(b.α, b.kinesin)], shininess=32.0)
    end

    GLMakie.scale!(scene, 0.05, 0.05, 0.05)
    center!(scene)
    return scene
end
