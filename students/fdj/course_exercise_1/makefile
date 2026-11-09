FC      = gfortran
FFLAGS  = -Wall -O2
TARGET  = exercise_1
OBJS    = geometry.o particle.o ex1.o

$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) -o $@ $(OBJS)

%.o: %.f90
	$(FC) $(FFLAGS) -c $<

# Dependencies
particle.o: geometry.o
ex1.o: particle.o geometry.o

.PHONY: clean
clean:
	rm -f *.o *.mod $(TARGET)