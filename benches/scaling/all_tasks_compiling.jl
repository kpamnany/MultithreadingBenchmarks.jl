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

function all_tasks_compiling(i, v, n)
    out = v
    for i in 1:n
        mul = @eval (a) -> a*$v
        out = Base.invokelatest(mul, out)
    end
    return out
end

const NumDatapoints = 5
const NumOps = 100

@btime run_task_bench(all_tasks_compiling, NumDatapoints, NumOps)
