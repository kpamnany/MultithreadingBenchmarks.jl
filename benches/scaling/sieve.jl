using Base.Threads
using BenchmarkTools

function sieve(numPrimes::Integer, nqueue::Int=5)
    done = Atomic{Bool}(false)
    primes = Int[]
    sieves = [Channel{Int}(nqueue) for i = 1:numPrimes]
    for i in 1:numPrimes
        @spawn begin
            sieve = sieves[i]
            p = take!(sieve)
            push!(primes, p)
            if length(primes) == numPrimes
                # don't pass it on--we're done now
                #= TODO: add an atomic write release barrier here =#
                done[] = true
                return
            end
            mp = p # mp is a multiple of p
            for m in sieve
                while m > mp
                    mp += p
                end
                if m < mp
                    put!(sieves[i + 1], m)
                end
            end
        end
    end
    put!(sieves[1], 2)
    n = 3
    while !done[]
        put!(sieves[1], n)
        n += 2
    end
    foreach(close, sieves)
    return primes
end

@btime sieve(2000)
