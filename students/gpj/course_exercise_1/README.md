# Course exercise 1: N-body simulation

Gravity simulation of N particles using the leapfrog method.
Still in progress (makefile, OpenMP and timing study missing).

## Files

- `geometry.f90`: module with the types `point3d` and `vector3d`, their operators and `distance`.
- `particle.f90`: module with the type `particle3d` (position `p`, velocity `v`, mass `m`).
- `ex1.f90`: the main program. Reads the input file, runs the simulation and writes `output.dat`.

## Compile and run

```bash
gfortran -Wall -c geometry.f90 particle.f90
gfortran -Wall -o ex1 geometry.o particle.o ex1.f90
./ex1 input.dat
```

Each line of `output.dat` is `t p1x p1y p1z ... pnx pny pnz`.

## Test

With `input.dat` the three bodies follow a figure-eight orbit, and it repeats correctly.

