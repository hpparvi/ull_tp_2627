#!bin/bash
#Timing study for exercise 1: run time of ex1_omp for several numbers of
#particles (N) and threads. The results go into timings.txt.
#
#   bash timing.sh
#
# Each case is run REPS times and the minimum time is kept.

NS="1000 2000 5000 10000"
THREADS="1 2 4 8"
REPS=3

# Build the programs
make
gfortran -O2 -o random_sphere random_sphere.f90

# Initial conditions: always the same particles (seed 42).
# Line 2 is dt_out: set it equal to t_end (0.1) so that output does not count.
for n in $NS; do
  ./random_sphere $n 42 | sed '2s/.*/ 0.10000/' > sphere_$n.dat
done

# Run every case REPS times and keep the minimum wall time (in seconds)
TIMEFORMAT=%R
echo "# N threads min_time(s) all_times(s)" > timings.txt
for n in $NS; do
  for t in $THREADS; do
    times=""
    for r in $(seq $REPS); do
      s=$( { time OMP_NUM_THREADS=$t ./ex1_omp sphere_$n.dat; } 2>&1 )
      times="$times $s"
    done
    best=$(echo $times | tr ' ' '\n' | sort -g | head -1)
    echo "$n $t $best $times" | tee -a timings.txt
  done
done
