# Makefile for course exercise 1: direct N-body simulation

FC = gfortran
FFLAGS = -Wall -O2
# For debugging: make FFLAGS="-Wall -g -fcheck=all"

PROG = ex1
OBJS = geometry.o particle.o ex1.o

.PHONY: all run clean

all: $(PROG) $(PROG)_omp

$(PROG): $(OBJS)
	$(FC) $(FFLAGS) -o $@ $^

# Generic rule: compile one source file into an object file
%.o: %.f90
	$(FC) $(FFLAGS) -c $<

# Module dependencies: a file that uses a module needs its .mod first
particle.o: geometry.o
ex1.o: geometry.o particle.o

# The same program compiled with OpenMP. The modules have no OpenMP code,
# so only ex1.f90 is compiled again, with -fopenmp.
$(PROG)_omp: geometry.o particle.o ex1.f90
	$(FC) $(FFLAGS) -fopenmp -o $@ $^

run: $(PROG)
	./$(PROG) input.dat

clean:
	rm -f *.o *.mod $(PROG) $(PROG)_omp output.dat
