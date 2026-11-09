FC = gfortran
FCFLAGS = -Wall -O2 -fopenmp
EXECUTABLE = ex1
FILES = geometry.f90  particle.f90 gravitational_acceleration.f90 read_input.f90 ex1.f90

all: $(EXECUTABLE)

$(EXECUTABLE): $(FILES)
	$(FC) $(FCFLAGS) $(FILES) -o $(EXECUTABLE)
	rm -f *.o *.mod
	
clean:
	rm -f $(EXECUTABLE)*.o *.mod
