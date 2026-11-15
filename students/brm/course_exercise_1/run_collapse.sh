#!/bin/bash

# Compile the project (random_sphere, ex1, and ex1_omp)
echo "Compiling project executables..."
make
gfortran -Wall -O2 -o random_sphere random_sphere.f90

N=1000
SEED=1126
INPUT_FILE="sphere_collapse.dat"

echo "Generating initial conditions for N = $N particles..."
./random_sphere $N $SEED > $INPUT_FILE

# Patch line 2 (dt_out = 0.01) and line 3 (t_end = 1.0) so we get 100 output steps
# across a full gravitational collapse (1000 total integration steps with dt = 0.001)
awk 'NR==2 {$0="0.01"} NR==3 {$0="1.0"} 1' $INPUT_FILE > temp.dat && mv temp.dat $INPUT_FILE
echo "Configured $INPUT_FILE with dt_out = 0.01 and t_end = 1.0."

# Run the OpenMP simulation with the 'energy' diagnostic flag enabled
export OMP_NUM_THREADS=8
echo "Running OpenMP N-body collapse simulation with energy diagnostics (OMP_NUM_THREADS = $OMP_NUM_THREADS)..."
./ex1_omp $INPUT_FILE energy
echo "Simulation complete! Output saved to output.dat and energy.dat."

# Run the Python plotting script
if [ -f "plot.py" ]; then
    echo "Generating 3D snapshots and energy conservation plots using plot.py..."
    python3 plot.py $INPUT_FILE output.dat energy.dat
else
    echo "Warning:plot.py was found in the current directory."
fi