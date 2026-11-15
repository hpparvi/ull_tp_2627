#!/bin/bash
# bench.sh
for N in 1000 2000 5000 10000; do
  ./random_sphere $N 42 > input_$N.dat     # semilla fija: mismas partículas siempre
  for T in 1 2 4 8; do
    export OMP_NUM_THREADS=$T
    s=$(date +%s.%N)
    ./exercise_1_omp input_$N.dat
    e=$(date +%s.%N)
    echo "$N $T $(echo "$e - $s" | bc -l)"
  done
done | tee timings.txt