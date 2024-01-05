
@inline @fastmath function torque_and_force(v, r, K)
    d = norm(r)
    r ./= d
    if all(r .≈ v)
        return zeros(3), zeros(3)
    end

    rdotv = min(1, abs(dot(r,v)))
    torque = K*sqrt(1.0-rdotv^2)*normalize(cross(r, v))
    force = -K/d*(v - rdotv*r)
    return torque, force
end


function angular_forces!(F, i, b1, beads, bead_info, dirs, K)
    @unpack north, east, south, west = bead_info

    torque = MVector{3,Float64}(0,0,0)
    bonds = [north, east, south, west]
    for (bond,dir) in zip(bonds,eachcol(dirs))
        if bond != 0
            # transform bond direction according to bead orientation
            v = orientate_vector(dir, b1.q)
            @fastmath r = beads[bond].x - b1.x
            # torque from diff between rest direction v and actual r
            τ, F_ = torque_and_force(v, r, K)
            @. F[:,bond] -= F_ 
            @. F[:,i] += F_
            torque += τ
        end
    end
    return torque
end
