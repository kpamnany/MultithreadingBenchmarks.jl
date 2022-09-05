using Base.Threads
using BenchmarkTools

function run_task_bench(f, N, n)
    vs = fill(0, N)
    @sync begin
        for i = 1:N
            @spawn begin
                vs[i] = f(i, 2, n)
            end
        end
    end
    sum(vs)
end

@noinline mul_barrier(a,b) = a*b
@noinline mul_barrier(a::Vector,b) = a[1]*b
@noinline mul_barrier(a,b::Vector) = a*b[1]

function all_tasks_allocating(i, v, n)
    ALLOC_EVERY_N = 100
    out = v
    for i in 1:n
        out_temp = if (i % ALLOC_EVERY_N == 0)
            vi = rand([[v], v])
            typeof(v)(mul_barrier(out, v))
        else
            out * v
        end
        out_temp::typeof(v)
        out = out_temp
    end
    return out
end

const NumDatapoints = 11
const NumOps = 50_000_000

@btime run_task_bench(all_tasks_allocating, NumDatapoints, NumOps)
