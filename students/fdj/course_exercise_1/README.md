## Usage

### Build

```bash
make                  # builds both versions
make exercise_1       # serial only
make exercise_1_omp   # OpenMP only
make clean            # removes build/ and the executables
```

The serial and OpenMP versions are built from the same source in separate directories (`build/serial`, `build/omp`). Requires `gfortran`.

### Input file

A plain-text file whose name is given as the command-line argument:

```
dt                  time step
dt_out              time between outputs
t_end               end time of the simulation
n                   number of particles
m x y z vx vy vz    mass, position and velocity (one line per particle)
```

Units are chosen so that G = 1.

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

The OpenMP version also prints the wall time of the simulation loop to stderr
(`Time: ... s`). For the serial version, use `time ./exercise_1 input.dat`.
When timing, set `dt_out = t_end` so that writing the output does not dominate.

### Checking that serial and OpenMP agree

```bash
./exercise_1 input.dat && mv output.dat out_serial.dat
OMP_NUM_THREADS=4 ./exercise_1_omp input.dat && mv output.dat out_omp.dat
diff out_serial.dat out_omp.dat && echo "identical"
```

### Plotting

If both output files are named that way, there is no need to
include them in the call.

```bash
python3 visualization.py output.dat output_original.dat  # comparison with the original code
```