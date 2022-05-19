# MultithreadingBenchmarks.jl

This is a suite of multithreaded kernels that exhibit a variety of parallel
patterns. It is intended to serve as an objective measure of Julia's
multithreading performance; specifically, we intend to use this suite to direct
the development of Julia's task scheduler and task/thread constructs.

There are two parts:
- scalable: programs in Julia used to evaluate scalability
- comparative: programs in Julia used to compare performance against programs
  in C+OpenMP
  
For the comparative tests, we borrow the parallel patterns along with their
implementations in C+OpenMP from the [Parallel Research Kernels](https://github.com/ParRes/Kernels)
and define fixed problem sizes for each in order to use them as benchmarks for
comparing multithreading performance.
