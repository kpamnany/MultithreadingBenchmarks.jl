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

function simple_independent(i, v, n)  # For n=10000000, takes ~2ms
    out = v
    for i in 1:n
        out *= v
    end
    out
end

const NumDatapoints = 51
const NumOps = 100_000_000

@btime run_task_bench(simple_independent, NumDatapoints, NumOps)
