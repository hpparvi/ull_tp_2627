# Course exercise 1: N-body simulation

Gravity simulation of N particles using the leapfrog method.
Still in progress (OpenMP and timing study missing).

## Files

- `geometry.f90`: module with the types `point3d` and `vector3d`, their operators and `distance`.
- `particle.f90`: module with the type `particle3d` (position `p`, velocity `v`, mass `m`).
- `ex1.f90`: the main program. Reads the input file, runs the simulation and writes `output.dat`.
- `Makefile`: compiles the modules and the program in the right order.

## Compile and run

```bash
make          # compile
make run      # compile (if needed) and run with input.dat
make clean    # remove the compiled files and output.dat
```

Or run it with any other input file:

```bash
./ex1 input.dat
```

Each line of `output.dat` is `t p1x p1y p1z ... pnx pny pnz`.

## Test

With `input.dat` the three bodies follow a figure-eight orbit, and it repeats correctly.

