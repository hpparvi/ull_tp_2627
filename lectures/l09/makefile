FC = gfortran
FCFLAGS = -Wall -fopenmp
PROGRAMS = hello_omp thread_ids thread_ids_portable parallel_loop collapse race reduction

all: $(PROGRAMS)

%: %.f90
	$(FC) $(FCFLAGS) -o $@ $<

clean:
	rm -f $(PROGRAMS)

.PHONY: all clean
