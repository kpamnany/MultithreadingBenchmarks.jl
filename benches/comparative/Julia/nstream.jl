# Updated for MultithreadingBenchmarks.jl

#
# Copyright (c) 2020, Intel Corporation
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
# * Neither the name of Intel Corporation nor the names of its
#      contributors may be used to endorse or promote products
#      derived from this software without specific prior written
#      permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

#*******************************************************************
#
# NAME:    nstream
#
# PURPOSE: To compute memory bandwidth when adding a vector of a given
#          number of double precision values to the scalar multiple of
#          another vector of the same length, and storing the result in
#          a third vector.
#
# USAGE:   The program takes as input the number
#          of iterations to loop over the triad vectors, the length of the
#          vectors, and the offset between vectors
#
#          <progname> <# iterations> <vector length> <offset>
#
#          The output consists of diagnostics to make sure the
#          algorithm worked, and of timing statistics.
#
# NOTES:   Bandwidth is determined as the number of words read, plus the
#          number of words written, times the size of the words, divided
#          by the execution time. For a vector length of N, the total
#          number of words read and written is 4*N*sizeof(double).
#
#
# HISTORY: This code is loosely based on the Stream benchmark by John
#          McCalpin, but does not follow all the Stream rules. Hence,
#          reported results should not be associated with Stream in
#          external publications
#
#          Converted to Python by Jeff Hammond, October 2017.
#
# *******************************************************************

const doc = """nstream.jl -- STREAM triad: A = B + scalar * C
Usage:
    nstream.jl [--iterations=<K>] [--length=<N>] [--verify] [--verbose]
    nstream.jl -h | --help
    nstream.jl --version
Options:
    -h --help           Show this screen.
    --version           Show version.
    --iterations=<K>    Number of iterations [default: 100].
    --length=<N>        Vector length [default: 2000000].
    --verify            Validate solution.
    --verbose           Show details.
"""

using Base.Threads
using DocOpt

include("common.jl")

const args = docopt(doc, version = PRKVERSION)

const Scalar = 3.0      # constant used in Triad

function triad!(A, B, s, C)
    @threads for i in 1:length(A)
        @inbounds A[i] += B[i] + s * C[i]
    end
end

function main(args)
    iterations = parse(Int, args["--iterations"])
    @assert iterations >= 1
    vlength = parse(Int, args["--length"])
    @assert vlength >= 1

    if args["--verbose"]
        println("Number of threads    = ", nthreads())
        println("Number of iterations = ", iterations)
        println("Vector length        = ", vlength)
    end

    A = fill(0.0, vlength)::Vector{Float64}
    B = fill(2.0, vlength)::Vector{Float64}
    C = fill(2.0, vlength)::Vector{Float64}

    # force compilation of `triad!`
    triad!(zeros(Float64, 10), ones(Float64, 10), 10.0, fill(2.0, 10))

    t0 = time_ns()

    for k in 1:iterations
        triad!(A, B, Scalar, C)
    end

    t1 = time_ns()
    nstream_time = (t1 - t0) * 1e-9

    if args["--verify"]
        ar = 0.0
        for k in 1:iterations
            ar += 2.0 + Scalar * 2.0
        end
        ar *= vlength
        asum = sum(abs.(A))

        if abs(ar - asum) / asum > Epsilon
            if args["--verbose"]
                println("Results comparison:")
                println("        Expected checksum: ", ar)
                println("        Observed checksum: ", asum)
            end
            error("Solution did not validate")
        end
    end

    avgtime = nstream_time / iterations
    nbytes = 4.0 * sizeof(Float64) * vlength
    rate = 1e-6 * nbytes / avgtime
    println(avgtime, " sec")
    println(rate, " MB/sec")
end

main(args)

