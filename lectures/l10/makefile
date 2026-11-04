FC = gfortran
FCFLAGS = -Wall -fopenmp
PROGRAMS = single sections histogram

all: $(PROGRAMS)

%: %.f90
	$(FC) $(FCFLAGS) -o $@ $<

clean:
	rm -f $(PROGRAMS)

.PHONY: all clean
