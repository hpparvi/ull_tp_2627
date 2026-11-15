#!/bin/bash
# bench.sh: tiempos de exercise_1_omp para varios N y número de hilos
export LC_ALL=C                    # punto decimal, sea cual sea el locale

DT=0.001
NSTEPS=20
TEND=$(echo "$DT * $NSTEPS" | bc -l)
EXE=./exercise_1_omp
REPS=5
OUT=timings.md
NS=(1000 2000 5000 10000)
PS=(1 2 4 8)

[ -x ./random_sphere ] && [ -x $EXE ] || { echo "Falta random_sphere o $EXE" >&2; exit 1; }
mkdir -p inputs outputs

declare -A T

for N in "${NS[@]}"; do
  { echo $DT; echo $TEND; echo $TEND; ./random_sphere $N 42 | tail -n +4; } > inputs/input_$N.dat

  for p in "${PS[@]}"; do
    OMP_NUM_THREADS=$p $EXE inputs/input_$N.dat >/dev/null 2>&1    # calentamiento

    T[$N,$p]=$(for r in $(seq $REPS); do
                 OMP_NUM_THREADS=$p $EXE inputs/input_$N.dat 2>&1 >/dev/null | awk '/Time:/{print $2}'
                 mv output.dat outputs/output_${N}_${p}.dat
               done | sort -n | awk '{a[NR]=$1} END{print a[int((NR+1)/2)]}')
    echo "N=$N p=$p T=${T[$N,$p]} s" >&2
  done
done

{
  echo "### Run Time (seconds)"
  printf "| Threads |"; for N in "${NS[@]}"; do printf " N = %d |" $N; done; echo
  printf "| :--- |";     for N in "${NS[@]}"; do printf " :--- |"; done; echo
  for p in "${PS[@]}"; do
    printf "| **%d** |" $p
    for N in "${NS[@]}"; do printf " %.2f |" ${T[$N,$p]}; done; echo
  done
} > $OUT

cat $OUT