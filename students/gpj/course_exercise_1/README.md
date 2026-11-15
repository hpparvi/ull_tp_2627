# Course exercise 1: N-body simulation

Gravity simulation of N particles using the leapfrog method, parallelised with OpenMP.

## Files

- `geometry.f90`: module with the types `point3d` and `vector3d`, their operators and `distance`.
- `particle.f90`: module with the type `particle3d` (position `p`, velocity `v`, mass `m`).
- `ex1.f90`: the main program. Reads the input file, runs the simulation and writes `output.dat`.
- `Makefile`: compiles the modules and the program in the right order, with and without OpenMP.
- `timing.sh`: runs the timing study.
- `timings.txt`: results of the timing study.

`input.dat` (three bodies on a figure-eight orbit) and `random_sphere.f90` are in `lectures/exercise_1/`.

## How it works

1. `ex1` reads `dt`, `dt_out`, `t_end`, `n` and the particles from the input file.
2. It computes the accelerations at t = 0 in the subroutine `accelerations`.
3. Then, for each time step (leapfrog, kick-drift-kick):
   - kick: `v = v + a dt/2`
   - drift: `p = p + v dt`
   - compute the new accelerations from the new positions
   - kick: `v = v + a dt/2`
4. Every `dt_out` it writes the positions into `output.dat`.

The force calculation takes almost all the time, so it is the part parallelised with OpenMP (`!$omp parallel do` over the particles). Each thread only computes and writes the acceleration of its own particles, so two threads never write to the same place.

## Compile and run

```bash
make          # compile ex1 (serial) and ex1_omp (OpenMP)
make run      # compile (if needed) and run with input.dat
make clean    # remove the compiled files and output.dat
```

Or run it with any other input file:

```bash
OMP_NUM_THREADS=4 ./ex1_omp input.dat
```

Each line of `output.dat` is `t p1x p1y p1z ... pnx pny pnz`.

## Timing study

`timing.sh` creates the initial conditions with `random_sphere.f90` (seed 42, so every run uses the same particles), sets `dt_out = t_end` so that writing the output does not count, and runs `ex1_omp` for N = 1000, 2000, 5000 and 10000 with 1, 2, 4 and 8 threads (100 time steps each). The results are in `timings.txt`.

Each case is run 3 times and the minimum time is kept. On a laptop the times change a lot from one run to the next (other programs, CPU frequency, fast or slow cores), and the minimum is the run with the least interference. The laptop was plugged in and in maximum performance mode.

Speed-up = time with 1 thread / time with n threads.

| N | Threads | Time (s) | Speed-up |
|---|---|---|---|
| 1000 | 1 | 0.59 | 1.00 |
| 1000 | 2 | 0.34 | 1.72 |
| 1000 | 4 | 0.40 | 1.49 |
| 1000 | 8 | 0.24 | 2.41 |
| 2000 | 1 | 2.42 | 1.00 |
| 2000 | 2 | 1.37 | 1.76 |
| 2000 | 4 | 1.41 | 1.71 |
| 2000 | 8 | 0.89 | 2.71 |
| 5000 | 1 | 13.68 | 1.00 |
| 5000 | 2 | 8.69 | 1.57 |
| 5000 | 4 | 8.35 | 1.64 |
| 5000 | 8 | 5.88 | 2.33 |
| 10000 | 1 | 59.84 | 1.00 |
| 10000 | 2 | 43.49 | 1.38 |
| 10000 | 4 | 33.30 | 1.80 |
| 10000 | 8 | 24.42 | 2.45 |

What we see:

- **The time grows as N²**: doubling N makes it about 4 times slower (0.59 s → 2.42 s), as expected because every step computes all the pairs of particles.
- **The speed-up is far from ideal** (about 1.7 with 2 threads and 2.5 with 8). My laptop CPU (i7-1255U) has only 2 fast cores and 8 slower ones, so with more than 2 threads some of them run on slow cores, and with `schedule(static)` the slowest thread sets the total time.
- To avoid race conditions, the OpenMP version computes every pair twice (each thread only writes its own `a(i)`), but it gives exactly the same results with and without OpenMP.

## Test

With `input.dat` the three bodies follow a figure-eight orbit, and it repeats correctly.

