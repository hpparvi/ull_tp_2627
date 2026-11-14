## Compiling

Use make inside the directory in wich is saved "ex1.f90". Two executables will be created. Once is called ex1, the second one ex1_no_paral. The first one execute the code with the OMP library, the second one does not.

## checking times:
1. Generate the input file using the executable "sphere" first you should compile it. Once is compiled execute it using: $./sphere <n_particles>
2. Execute $ ./ex1 <Input.dat>. This gives the executing time when the run is finalized and a results.dat
3. Executed with 1000, 2000, 4000, 10000. Results:


| n Particles | without |  THREADS=1  |   THREADS=2  |  THREADS=4  |  THREADS=8  |
|-----------|-----------|-----------|-----------|-----------|-----------|
| 1000   | 0.32364 s   | 0.30479 s   | 0.18379 s   | 0.11783 s   | 0.25031 s   |
| 2000   | 1.1998 s    | 1.1356 s    | 0.64184 s   | 0.36479 s   | 0.43252 s   |
| 5000   | 6.9515 s    | 6.9665 s    | 3.6460 s    | 2.2869 s    | 2.0991 s    |
| 10000  | 27.815 s    | 27.565 s    | 14.454 s    | 8.6599 s    | 7.7839 s    |

## Code

The code works with 5 files:

1. ex1.f90: main code. Employ modules in geometry.f90, particle.f90, read_input.f90, gravitational_acceleration.f90. Use leapfrog algorithm to solve a gravitational Nbody problem.
2. geometry.f90: Create type vector3d, and point3d and it's relations and a distance function between 2 points.
3. particle.f90: Create type particles with position(point3d), velocity(vector3d) and mass(real_64)
4. read_input.f90: Include module input which reads the input file and returns an array particle type.
5. gravitational_acceleration.f90: Include module acceleration which returns the acceleration of a single particle due to the others.

