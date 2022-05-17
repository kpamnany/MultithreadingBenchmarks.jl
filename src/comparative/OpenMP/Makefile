# Compiler
#
CC=gcc -std=c11 -I. -fopenmp -fopenmp-simd
EXTRA_CLIBS=-lm
#EXTRA_CLIBS=-lrt

# Compiler options
#
# -mtune=native is appropriate for most cases.
# -march=native is appropriate if you want portable binaries.
CFLAGS=-O3 -mtune=native -ffast-math
#CFLAGS=-O0
CFLAGS+=-g3
#CFLAGS+=-fsanitize=undefined
#CFLAGS+=-fsanitize=undefined,leak
#CFLAGS+=-fsanitize=address
#CFLAGS+=-fsanitize=thread
#CFLAGS+=-fopt-info-vec-missed
CFLAGS+=-Wall #-Werror
CFLAGS+=-mavx -mfma # these should be used on Haswell and later


# Tuning options for the various kernels
#
# common
ifndef VERBOSE
  VERBOSE=0
endif
#description: default diagnostic style is silent
TUNEFLAGS=-DVERBOSE=$(VERBOSE)

ifndef RESTRICT_KEYWORD
  RESTRICT_KEYWORD=0
endif
#description: the "restrict" keyword can be used on IA platforms to disambiguate  
#             data accessed through pointers (requires -restrict compiler flag)
TUNEFLAGS+=-DRESTRICT_KEYWORD=$(RESTRICT_KEYWORD)

ifndef MAXTHREADS
  MAXTHREADS=64
endif
#description: default thread limit is 64
TUNEFLAGS+=-DMAXTHREADS=$(MAXTHREADS)

# branch

# dgemm
ifndef MKL
  MKL=0
endif
#description: set this flag to call the tuned mkl library
TUNEFLAGS+=-DMKL=$(MKL)

ifndef DEFAULTBLOCK
  DEFAULTBLOCK=32
endif
#description: default tile size is 32 (used only for non-MKL version)
TUNEFLAGS+=-DDEFAULTBLOCK=$(DEFAULTBLOCK)

ifndef BOFFSET
  BOFFSET=12
endif
#description: set this flag to some value to override default first array 
#             dimension padding (12) of tiles used in non-MKL version
TUNEFLAGS+=-DBOFFSET=$(BOFFSET)

# nstream
ifndef MAXLENGTH
  MAXLENGTH=2000000
endif
#description: default vector length (if static) is 2000000
TUNEFLAGS+=-DMAXLENGTH=$(MAXLENGTH)

ifndef STATIC_ALLOCATION
  STATIC_ALLOCATION=0
endif
#description: default memory allocation is dynamic (using prk_malloc)
TUNEFLAGS+=-DSTATIC_ALLOCATION=$(STATIC_ALLOCATION)

# p2p
ifndef SYNCHRONOUS
  SYNCHRONOUS=0
endif
#description: default handshake between threads is off
TUNEFLAGS+=-DSYNCHRONOUS=$(SYNCHRONOUS)

# pic

# random
ifndef HPCC
  HPCC=1
endif
#description: Uses HPC Challenge rules: non-atomic updates, shared table, 
#             1% errors allowed; overrides ATOMICFLAG, CHUNKFLAG, ERRORPERCENTFLAG
TUNEFLAGS+=-DHPCC=$(HPCC)

ifndef ATOMIC
  ATOMIC=0
endif
#description: protect threads from simultaneous access to same memory location
TUNEFLAGS+=-DATOMIC=$(ATOMIC)

ifndef CHUNKED
  CHUNKED=0
endif
#description: assign chunks of Table to different threads, so no atomic needed
TUNEFLAGS+=-DCHUNKED=$(CHUNKED)

ifndef ERRORPERCENT
  ERRORPERCENT=1
endif
#description: percent errors allowed in solution; if unset, no errors allowed
TUNEFLAGS+=-DERRORPERCENT=$(ERRORPERCENT)

ifndef LONG_IS_64BITS
  LONG_IS_64BITS=0
endif
#description: can use "long" for 64 bit integers instead of "long long"
TUNEFLAGS+=-DLONG64FLAG=$(LONG64FLAG)

# reduce

# sparse
ifndef SCRAMBLE
 SCRAMBLE=1
endif
#description: if flag is true, grid indices are scrambled to produce irregular stride
TUNEFLAGS+=-DSCRAMBLE=$(SCRAMBLE)

# stencil
ifndef DOUBLE
  DOUBLE=1
endif
#description: default data type is double precision
TUNEFLAGS+=-DDOUBLE=$(DOUBLE)

ifndef PARALLELFOR
  PARALLELFOR=0
endif
#description: default is a single parallel region for all iterations
TUNEFLAGS+=-DPARALLELFOR=$(PARALLELFOR)

ifndef STAR
  STAR=1
endif
#description: default stencil is star-shaped
TUNEFLAGS+=-DSTAR=$(STAR)

ifndef RADIUS
  RADIUS=2
endif
#description: default radius of filter to be applied is 2
TUNEFLAGS+=-DRADIUS=$(RADIUS)

ifndef LOOPGEN
  LOOPGEN=0
endif
#description: default is compact (non-expanded) form of loop body
TUNEFLAGS+=-DLOOPGEN=$(LOOPGEN)

# transpose
ifndef COLLAPSE
  COLLAPSE=0
endif
#description: collapse outer two loops in case of tiling to increase concurrency
TUNEFLAGS+=-DCOLLAPSE=$(COLLAPSE)


# rules
all: branch dgemm nstream p2p pic random reduce stencil transpose

branch: branch.o wtime.o bail_out.o func.o
	$(CC) -o branch $(CFLAGS) $(TUNEFLAGS) $?

dgemm: dgemm.o wtime.o bail_out.o
	$(CC) -o dgemm $(CFLAGS) $(TUNEFLAGS) $?

nstream: nstream.o wtime.o bail_out.o
	$(CC) -o nstream $(CFLAGS) $(TUNEFLAGS) $?

p2p: p2p.o wtime.o bail_out.o
	$(CC) -o p2p $(CFLAGS) $(TUNEFLAGS) $?

pic: pic.o wtime.o bail_out.o random_draw.o
	$(CC) -o pic $(CFLAGS) $(TUNEFLAGS) $? $(EXTRA_CLIBS)

random: random.o wtime.o bail_out.o
	$(CC) -o random $(CFLAGS) $(TUNEFLAGS) $?

reduce: reduce.o wtime.o bail_out.o
	$(CC) -o reduce $(CFLAGS) $(TUNEFLAGS) $?

sparse: sparse.o wtime.o bail_out.o
	$(CC) -o sparse $(CFLAGS) $(TUNEFLAGS) $?

stencil: stencil.o wtime.o bail_out.o
	$(CC) -o stencil $(CFLAGS) $(TUNEFLAGS) $?

transpose: transpose.o wtime.o bail_out.o
	$(CC) -o transpose $(CFLAGS) $(TUNEFLAGS) $?

.c.o:
	$(CC) $(CFLAGS) $(TUNEFLAGS) -c $<
 
# func_gen
ifndef NUMBER_OF_FUNCTIONS
  NUMBER_OF_FUNCTIONS=40
endif

ifndef MATRIX_RANK
  MATRIX_RANK=10
endif

func.c:
	@echo "############################################################"
	@echo "##### No file func.c -- invoking func_gen to create it #####"
	@echo "############################################################"
	./func_gen ${MATRIX_RANK} ${NUMBER_OF_FUNCTIONS}

clean:
	rm -f random_draw.o func.o bail_out.o wtime.o \
		branch.o branch \
		dgemm.o dgemm \
		nstream.o nstream \
		p2p.o p2p \
		pic.o pic \
		random.o random \
		reduce.o reduce \
		stencil.o stencil \
		transpose.o transpose

veryclean:
	@rm -f func.c ___*
	make clean  
