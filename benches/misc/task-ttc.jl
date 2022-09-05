# 50000 tasks that each take 0.2 seconds. Admission control to ensure
# there are never more than 500 tasks running. I see e.g. the 108th
# task finishes in 19619th place with a duration of 347 seconds, and
# at one point it goes unscheduled for more than 4 minutes.
#
# JULIA_NUM_THREADS=4

using Base.Threads
using BEnchmarkTools

const sem = Base.Semaphore(500)
const max_span = Atomic{Float64}(0.0)
const completion_count = Atomic{Int}(0)

function foo(spawn_seq::Int, z::UInt64)
    try
        t0 = time()
        yield_times = Vector{Float64}()
        h = UInt64(z)

        # Do some busy work, yield frequently
        for i=1:100000000
            h = hash(i, h)
            if mod(i,1000000) == 0
               t1 = time()
               yield()
               t2 = time()
               push!(yield_times, (t2-t1))
            end
        end
        completion_seq = 1+atomic_add!(completion_count, 1)
        # For scatter plot of completion sequence vs spawn sequence
        print("$(spawn_seq),$(completion_seq)\n")
        Base.release(sem)
        span = time() - t0
        prev_max_span = max_span[]
        if span > max(10, prev_max_span)
            if atomic_cas!(max_span, prev_max_span, span) == prev_max_span
                sort!(yield_times, rev=true)
                print("#@ spawn_seq=$(spawn_seq) completion_seq=$(completion_seq) span=$(span) yield_times=$(yield_times)\n")
            end
        end
    catch e
        print("error\n")
        showerror(stderr, e, catch_backtrace())
        throw()
    end
    return h
end

function bar(N::Int)
    u = UInt64(0)
    for j in 1:N
        Base.acquire(sem)
        arg = j
        @spawn foo(arg, u)
        u = hash(j, u)
        sleep(1/N)
    end
end

@btime bar(50000)
