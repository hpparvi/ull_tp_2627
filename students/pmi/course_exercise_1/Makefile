FC = gfortran
FLAGS = -fopenmp -O2

ENV = .venv/bin/python  # We need a venv in the same folder in order to run the python script for visualization
TARGET = ex1
INPUT = input.dat
RESULTS = output.dat
IMAGE = orbits.png

.PHONY: all everything plot clean

all: $(TARGET)
	rm -f *.o *.mod

$(TARGET): Geometry.o Particle.o ex1.o
	$(FC) $(FLAGS) -o $(TARGET) Geometry.o Particle.o ex1.o

Geometry.o: Geometry.f90
	$(FC) $(FLAGS) -c Geometry.f90

Particle.o: Particle.f90 Geometry.o
	$(FC) $(FLAGS) -c Particle.f90

ex1.o: ex1.f90 Particle.o
	$(FC) $(FLAGS) -c ex1.f90



# make everything will do everything: compile, run and plot.
# In this case, we have to change the input manually if needed.
everything: all
	./$(TARGET) < $(INPUT)
	$(MAKE) plot


# We can just use 'make' as usual to compile, run the code manually and then use
# 'make plot' in order to run plot_orbits.py, which will create an image with the orbits.

plot:
	$(ENV) plot_orbits.py $(RESULTS) -o $(IMAGE)


clean:
	rm -f *.o *.mod $(TARGET)
