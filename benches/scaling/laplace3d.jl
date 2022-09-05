## 3D Laplace equation

using Base.Cartesian
using Base.Threads
using BenchmarkTools
using Printf

const sixth = 1.0f0/6.0f0
const error_tol = 0.00001
const iters = 100
const verify = false

function l3d_orig(u1::Array{Float32,3}, u3::Array{Float32,3},
                        nx::Int64, ny::Int64, nz::Int64)
    @nloops 3 k u1 begin
        if @nany 3 d->(k_d == 1 || k_d == size(u1, d))
            @inbounds (@nref 3 u3 k) = (@nref 3 u1 k)
        else
            @inbounds (@nref 3 u3 k) = (
                u1[k_1-1, k_2,   k_3  ] + u1[k_1+1, k_2,   k_3] +
                u1[k_1,   k_2-1, k_3  ] + u1[k_1,   k_2+1, k_3] +
                u1[k_1,   k_2,   k_3-1] + u1[k_1,   k_2,   k_3+1]
            ) * sixth
        end
    end
end

function init_u(nx = 290, ny = 290, nz = 290)
    u1 = zeros(Float32, nx, ny, nz)
    u3 = zeros(Float32, nx, ny, nz)
    @nloops 3 k u1 begin
        if @nany 3 d->(k_d == 1 || k_d == size(u1, d))
            (@nref 3 u3 k) = (@nref 3 u1 k) = 1.0
        end
    end
    return u1, u3
end

function laplace3d(u1, u3; iters = iters)
    local nx, ny, nz = size(u1)
    for n in 1:iters
        let u1 = u1, u3 = u3
            @threads for k_3 in 2:nz-1
                for k_2 in 2:ny-1
                    @simd for k_1 in 2:nx-1
                        @inbounds u3[k_1, k_2, k_3] = 
                            (u1[k_1-1, k_2,   k_3  ] + u1[k_1+1, k_2,   k_3] +
                             u1[k_1,   k_2-1, k_3  ] + u1[k_1,   k_2+1, k_3] +
                             u1[k_1,   k_2,   k_3-1] + u1[k_1,   k_2,   k_3+1]) * sixth
                    end
                end
            end
        end
        u1, u3 = u3, u1
    end
end

function verify_u(u)
    nx, ny, nz = size(u)
    u1_orig = zeros(Float32, nx, ny, nz)
    u3_orig = zeros(Float32, nx, ny, nz)
    @nloops 3 k u1_orig begin
        if @nany 3 d->(k_d == 1 || k_d == size(u1_orig, d))
            (@nref 3 u3_orig k) = (@nref 3 u1_orig k) = 1.0
        end
    end
    for n in 1:iters
        l3d_orig(u1_orig, u3_orig, nx, ny, nz)
        foo = u1_orig
        u1_orig = u3_orig
        u3_orig = foo
    end
    @nloops 3 k u1 begin
        if abs((@nref 3 u1 k) - (@nref 3 u1_orig k)) > error_tol
            error(@sprintf("Verify error: %f - %f [%d, %d, %d]\n",
                  (@nref 3 u1 k), (@nref 3 u1_orig k), k_1, k_2, k_3))
        end
    end
    println("verification succeeded")
end

u1, u3 = init_u()
@btime laplace3d(u1, u3)
verify && verify_u(u1)
