const doc = """run_benchmarks.jl -- multithreaded benchmarks test harness
Usage:
    run_benchmarks.jl (scaling|comparative|misc) [<name>] [options]
    run_benchmarks.jl -h | --help
    run_benchmarks.jl --version
Options:
    -n <runs>, --runs=<runs>    Number of runs for each benchmark [default: 5].
    -s <max>, --scale=<max>     Maximum number of threads for scaling [default: 8].
    -h, --help                  Show this screen.
    --version                   Show version.
"""

using DocOpt
using UnicodePlots

const args = docopt(doc, version = v"0.0.1")
const JULIAVER = Base.julia_cmd()[1]

function run_benches(bench::String, args)
    @show bench
    local runs = parse(Int, args["--runs"])
    local max = parse(Int, args["--scale"])
    local n = 0
    while true
        threads = 2^n
        threads > max && break
        @show threads
        for r in 1:runs
            @show r
            res = read(`$JULIAVER --project=. --threads=$threads $bench`)
            run(`$JULIAVER --project=. --threads=$threads $bench`)
        end
        n += 1
    end
end

function run_benches(::Nothing, args)
    for bench in filter(f -> endswith(f, ".jl"), readdir())
        run_benches(bench, args)
    end
end

function main(args)
    cd(joinpath(@__DIR__, "benches"))

    # select benchmark class
    if args["scaling"]
        cd("scaling")
    elseif args["comparative"]
        cd("comparative")
    else # args["misc"]
        cd("misc")
    end

    run_benches(args["<name>"], args)
end

main(args)
