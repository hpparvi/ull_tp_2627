FC = gfortran
FCFLAGS = -Wall -O2 -fopenmp
EXECUTABLE = ex1
EXECUTABLE2= ex1_no_paral
FILES = geometry.f90  particle.f90 gravitational_acceleration.f90 read_input.f90 ex1.f90
FCFLAGS2= -Wall -O2 
all: $(EXECUTABLE)

$(EXECUTABLE): $(FILES)
	$(FC) $(FCFLAGS) $(FILES) -o $(EXECUTABLE)
	$(FC) $(FCFLAGS2) $(FILES) -o $(EXECUTABLE2)
clean:
	rm -f $(EXECUTABLE) $(EXECUTABLE2) *.o *.mod 
