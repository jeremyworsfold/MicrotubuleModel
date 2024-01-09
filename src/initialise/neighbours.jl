
"""
    lateral_nn(idx::Int, total::Int)::Tuple{Int,Int}

Return neighbours in the lateral direction for bead `idx` of `total`
"""
function lateral_nn(idx::Int, total::Int)::Tuple{Int,Int}
    if idx % 13 == 0 
        if idx > total-2*13-1
            return (idx-1, 0)
        end
        return (idx-1, idx+1+2*13)
    elseif idx % 13 == 1
        if idx < 2*13+1
            return (0, idx+1)
        end
        return (idx-1-2*13, idx+1)
    end
    return (idx-1, idx+1)
end

"""
    lateral_nn(idx::Int, total::Int)::Tuple{Int,Int}

Return neighbours in the longitudinal direction for bead `idx` of `total`
"""
function long_nn(idx::Int, total::Int)::Tuple{Int,Int}
    if idx<14
        return idx+13, 0
    elseif idx>total-13
        return 0, idx-13
    end
    return idx+13, idx-13
end

"""
    lateral_nn(idx::Int, total::Int)::Tuple{Int,Int}

Return neighbours in the lateral direction for bead `idx` of `total` in a patch
"""
function lateral_nn_patch(idx::Int, N_lat::Int)::Tuple{Int,Int}
    if idx % N_lat == 0 
        return (idx-1, 0)
    elseif idx % N_lat == 1
        return (0, idx+1)
    end
    return (idx-1, idx+1)
end


"""
    long_nn_patch(idx::Int, N_lat::Int, N_long::Int)::Tuple{Int,Int}

Return neighbours in the long direction for bead `idx` of `total` in a patch
"""
function long_nn_patch(idx::Int, N_lat::Int, N_long::Int)::Tuple{Int,Int}
    if idx<N_lat+1
        return idx+N_lat, 0
    elseif idx>N_lat*(N_long-1)
        return 0, idx-N_lat
    end
    return idx+N_lat, idx-N_lat
end


"""
    neighbours(idx::Int, total::Int)

Return neighbours in the lateral and longitudinal direction for bead `idx` of `total`
"""
function neighbours(idx::Int, total::Int)::Tuple{Tuple{Int,Int}, Tuple{Int, Int}}
    return lateral_nn(idx, total), long_nn(idx, total)
end