## Usage

### Build

```bash
make                  # builds both versions
make exercise_1       # serial only
make exercise_1_omp   # OpenMP only
make clean            # removes build/ and the executables
```

The serial and OpenMP versions are built from the same source in separate
directories (`build/serial`, `build/omp`). Requires `gfortran`.

The initial-condition generator is compiled separately:

```bash
gfortran -O2 -o random_sphere random_sphere.f90
```

### Input file

A plain-text file whose name is given as the command-line argument:

```
dt                  time step
dt_out              time between outputs
t_end               end time of the simulation
n                   number of particles
m x y z vx vy vz    mass, position and velocity (one line per particle)
```

Units are chosen so that G = 1. Initial conditions can be generated with
`random_sphere`; the optional second argument is a seed, so the same particles
are obtained every time:

```bash
./random_sphere 1000 42 > input.dat
```

### Running

```bash
./exercise_1 input.dat                        # serial
OMP_NUM_THREADS=4 ./exercise_1_omp input.dat  # OpenMP, 4 threads
```

If no argument is given, the program prints a usage message to stderr.
If the file cannot be opened, the error is reported to stderr.

### Output

The positions are written to `output.dat` (overwritten on every run). Each line
holds the state at one output time:

```
t  p1a p1b p1c  p2a p2b p2c  ...  pna pnb pnc
```

The first line is the initial state (t = 0), and a new line is written every
`dt_out`.

### Timing output

The OpenMP version prints the wall-clock time of the simulation loop to stderr,
measured with `omp_get_wtime()`:

```
Time: .113 s
```

(gfortran's `f0.3` format omits the leading zero, so `.113` means 0.113 s.)
The serial version prints no time; use `time ./exercise_1 input.dat`.
When timing, set `dt_out = t_end` so that writing the output does not dominate.

Running under `time` gives three more values:

| Value | Meaning |
|---|---|
| `real` | Wall-clock time of the whole run. |
| `user` | CPU time summed over **all threads**. |
| `sys`  | CPU time spent in the kernel (I/O, memory allocation). |

Use `Time:` (wall-clock) to compare runs, never `user`, which does not decrease
when more threads are used.

## Parallelization

The accelerations are computed with `!$omp parallel do` over the particles `i`.

A loop over pairs (`j = i+1, n`) updates both `a(i)` and `a(j)`, so two threads
can update the same `a(j)` at the same time (a race condition) and one
contribution is lost. Looping over all `j /= i` and writing only to `a(i)`
gives every element a single owner thread, so there is no race and the result
does not depend on the number of threads. The cost is twice as many
interactions.

The OpenMP directives and the `!$` lines are comments without `-fopenmp`, so
both builds come from the same source.

### Checking that serial and OpenMP agree

The check was done with the output format `'(*(g0,1x))'`, which prints all
digits, so the comparison is exact:

```bash
./exercise_1 input.dat && mv output.dat out_serial.dat
OMP_NUM_THREADS=4 ./exercise_1_omp input.dat && mv output.dat out_omp.dat
diff out_serial.dat out_omp.dat && echo "identical"
```

## Benchmarks

```bash
./bench.sh            # creates inputs/, outputs/ and timings.md
```

Run times in seconds (median of 5 runs, `dt = 0.001`, 20 steps, `dt_out = t_end`,
seed 42). Two versions of the inner loop of `acceleration` were compared. Both
loop over all `j /= i` and write only to `a(i)`.

**Version A**: distance computed with `dist`:

```fortran
r3   = dist(part(j)%p, part(i)%p)**3
a(i) = a(i) + (part(j)%m * (rji / r3))
```

| Threads | N = 1000 | N = 2000 | N = 5000 | N = 10000 |
| :--- | :--- | :--- | :--- | :--- |
| **1** | 0.25 | 0.99 | 6.24 | 24.71 |
| **2** | 0.13 | 0.51 | 3.16 | 12.65 |
| **4** | 0.07 | 0.28 | 1.69 | 6.82 |
| **8** | 0.06 | 0.23 | 1.39 | 5.29 |

**Version B**: `r2` computed from `rji`, one scalar division per interaction:

```fortran
r2   = rji%x**2 + rji%y**2 + rji%z**2
r3   = r2 * sqrt(r2)
a(i) = a(i) + (part(j)%m / r3) * rji
```

| Threads | N = 1000 | N = 2000 | N = 5000 | N = 10000 |
| :--- | :--- | :--- | :--- | :--- |
| **1** | 0.90 | 1.19 | 7.34 | 29.60 |
| **2** | 0.44 | 0.60 | 3.76 | 15.16 |
| **4** | 0.12 | 0.32 | 1.95 | 7.87 |
| **8** | 0.06 | 0.20 | 1.25 | 5.11 |

### Discussion

- **Scaling with N.** For N >= 5000 the time grows roughly as N^2 (from
  N = 5000 to 10 000 it is multiplied by about 4), as expected: each step
  computes N(N-1) interactions.
- **Scaling with threads.** For N = 10 000, version A reaches speed-ups of
  1.95, 3.62 and 4.67 with 2, 4 and 8 threads (version B: 1.95, 3.76 and 5.79).
  This is below the ideal value p, in agreement with Amdahl's law: the kick
  and drift updates (`part%v`, `part%p`), and the input and output, are serial,
  and a team of threads is created at every call to `acceleration`. The
  efficiency drops most from 4 to 8 threads, which is consistent with the
  machine having fewer than 8 physical cores (the extra threads share cores).
- **Small N.** For N = 1000 there is little work per thread compared with the
  fixed cost of creating and synchronising the team, so the speed-up is the
  worst and the measurements the least reliable (run times of a few tenths of
  a second).
- **The two versions.** Contrary to what one might expect, version B (which
  avoids the repeated subtraction in `dist` and two of the three divisions) is
  *not* faster in serial: with one thread it is about 20 % slower for
  N = 10 000 (29.6 s against 24.7 s). Possible causes are differences in how
  the compiler optimises or vectorises the two loops, but this was not tested. 
  With 8 threads the two versions are within about 4 % (5.11 s and 5.29 s for
  N = 10 000), so the difference disappears. The higher speed-up of B with 8 
  threads comes from its larger T(1), not from a shorter run time.
- **Reliability.** Each value is the median of only 5 runs, so there is
  noise. In version B the values for N = 1000 (0.90 s with 1 thread against
  0.12 s with 4 threads, a speed-up of 7.5) and N = 2000 with 1 thread
  (1.19 s, when N^2 scaling would suggest about 4 s... for N = 1000 times 4) do not follow the
  expected scaling and should be taken as outliers. The conclusions above rely
  on N >= 5000.
- **Cost of the parallel scheme.** Looping over all `j /= i` doubles the number
  of interactions compared with the pair loop (N(N-1) instead of N(N-1)/2), so
  with 2 threads one only matches a serial pair-loop code, and the gain
  appears with 4 or more threads.

### Plotting

`visualization.py` reads `output.dat` and `output_original.dat` by default, so
if the files are named that way there is no need to pass them:

```bash
python3 visualization.py
python3 visualization.py output.dat output_original.dat   # explicit
```