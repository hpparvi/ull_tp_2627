FC       = gfortran
FCFLAGS  = -Wall -O2
NAMES    = geometry particle ex1

SERIAL   = exercise_1
OMP      = exercise_1_omp

all: $(SERIAL) $(OMP)

$(SERIAL): $(NAMES:%=build/serial/%.o)
	$(FC) $(FCFLAGS) -o $@ $^

$(OMP): $(NAMES:%=build/omp/%.o)
	$(FC) $(FCFLAGS) -fopenmp -o $@ $^

build/serial/%.o: %.f90
	@mkdir -p build/serial
	$(FC) $(FCFLAGS) -Jbuild/serial -c $< -o $@

build/omp/%.o: %.f90
	@mkdir -p build/omp
	$(FC) $(FCFLAGS) -fopenmp -Jbuild/omp -c $< -o $@

# Module dependencies
build/serial/particle.o: build/serial/geometry.o
build/serial/ex1.o:      build/serial/particle.o
build/omp/particle.o:    build/omp/geometry.o
build/omp/ex1.o:         build/omp/particle.o

.PHONY: all clean
clean:
	rm -rf build $(SERIAL) $(OMP)
	rm -f *.o *.mod 