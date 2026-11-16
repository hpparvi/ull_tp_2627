# This code has been created with the help of an AI. Its only purpose is to check 
# the orbits of the particles in the simulation. This helped to confirm that the 
# code was working correctly and doesn't give much help with the rest of the project.


#!/usr/bin/env python3
"""Plot the particle trajectories stored in output.dat.

Expected data format (the one written by ex1.f90): one line per time step,
    t  x1 y1 z1  x2 y2 z2  ...  xn yn zn

The file may start with header/extra lines. They are skipped automatically
until the first fully numeric line with at least --min-cols columns is found;
from there on, every line must have that same number of columns.

Usage:
    python3 plot_orbits.py                      # output.dat -> orbits.png
    python3 plot_orbits.py data.dat -o fig.png
    python3 plot_orbits.py --show               # also open an interactive window
    python3 plot_orbits.py --min-cols 7         # change the data-detection threshold
"""
import argparse
import sys

import numpy as np


def load(path, min_cols):
    """Read the data block of `path`, skipping any leading non-data lines."""
    try:
        with open(path) as fh:
            lines = fh.readlines()
    except OSError:
        sys.exit(f"Cannot find '{path}'. Run ./ex1 < input.dat first.")

    rows = []
    ncols = None
    skipped = 0
    for lineno, line in enumerate(lines, start=1):
        parts = line.split()
        if not parts:  # blank line
            if ncols is None:
                skipped += 1
            continue

        if ncols is None:
            # Still looking for the start of the data zone
            if len(parts) < min_cols:
                skipped += 1
                continue
            try:
                vals = [float(p) for p in parts]
            except ValueError:
                skipped += 1
                continue
            ncols = len(vals)
            rows.append(vals)
            continue

        # Inside the data zone
        try:
            vals = [float(p) for p in parts]
        except ValueError:
            vals = None
        if vals is None or len(vals) != ncols:
            print(f"Warning: line {lineno} does not match the data format; "
                  "stopping reading there.", file=sys.stderr)
            break
        rows.append(vals)

    if ncols is None:
        sys.exit(f"No data found in '{path}': no numeric line with at least "
                 f"{min_cols} columns.")
    if skipped:
        print(f"Skipped {skipped} leading line(s) before the data.")

    data = np.array(rows)
    if data.shape[0] < 2:
        sys.exit("Fewer than 2 data lines: there is no trajectory to plot.")
    if (data.shape[1] - 1) % 3 != 0:
        sys.exit(f"Unexpected format: {data.shape[1]} columns (expected 1 + 3*N).")

    t = data[:, 0]
    n = (data.shape[1] - 1) // 3
    pos = data[:, 1:].reshape(len(t), n, 3)  # [time step, particle, xyz]
    return t, pos


def cube_limits(pos, dims):
    """Equal-extent axis limits (square/cube) around the data."""
    pts = pos.reshape(-1, 3)[:, dims]
    mins, maxs = pts.min(axis=0), pts.max(axis=0)
    centre = (mins + maxs) / 2
    half = max((maxs - mins).max() / 2, 1e-12) * 1.08
    return centre - half, centre + half


def static_plot(t, pos, planar, colors, args, plt):
    n = pos.shape[1]
    if planar:
        fig, ax2 = plt.subplots(figsize=(7.5, 7.5))
        ax3 = None
    else:
        fig = plt.figure(figsize=(14, 6.5))
        ax3 = fig.add_subplot(1, 2, 1, projection="3d")
        ax2 = fig.add_subplot(1, 2, 2)

    # If the orbits overlap (e.g. the figure-eight), use nested lines: the
    # first particle is the thickest and the last one the thinnest, so every
    # colour stays visible even when all bodies follow the same curve.
    for i in range(n):
        x, y, z = pos[:, i, 0], pos[:, i, 1], pos[:, i, 2]
        lw = 1.0 + 4.0 * (n - 1 - i) / max(n - 1, 1)
        c = colors[i]
        label = f"Particle {i + 1}"
        ax2.plot(x, y, color=c, lw=lw, alpha=0.9, label=label, solid_capstyle="round")
        ax2.plot(x[0], y[0], "o", color=c, mec="k", ms=7)
        ax2.plot(x[-1], y[-1], "s", color=c, mec="k", ms=9)
        if ax3 is not None:
            ax3.plot(x, y, z, color=c, lw=lw * 0.6, label=label)
            ax3.scatter(x[0], y[0], z[0], color=c, marker="o", s=30)
            ax3.scatter(x[-1], y[-1], z[-1], color=c, marker="s", s=30)

    lo, hi = cube_limits(pos, [0, 1])
    ax2.set_xlim(lo[0], hi[0])
    ax2.set_ylim(lo[1], hi[1])
    ax2.set_aspect("equal")
    ax2.set_xlabel("x")
    ax2.set_ylabel("y")
    ax2.set_title("XY plane  (● start, ■ end)")
    ax2.grid(alpha=0.3)
    if n <= 12:
        ax2.legend(loc="best", fontsize=8)

    if ax3 is not None:
        lo3, hi3 = cube_limits(pos, [0, 1, 2])
        ax3.set_xlim(lo3[0], hi3[0])
        ax3.set_ylim(lo3[1], hi3[1])
        ax3.set_zlim(lo3[2], hi3[2])
        ax3.set_box_aspect((1, 1, 1))
        ax3.set_xlabel("x")
        ax3.set_ylabel("y")
        ax3.set_zlabel("z")
        ax3.set_title("3D trajectories")

    fig.suptitle(f"{n} particles, t = {t[0]:g} → {t[-1]:g}  ({len(t)} points)")
    fig.tight_layout()
    fig.savefig(args.output, dpi=args.dpi)
    print(f"Image saved to {args.output}")
    return fig


def main():
    ap = argparse.ArgumentParser(description="Plot the orbits stored in output.dat")
    ap.add_argument("file", nargs="?", default="output.dat",
                    help="data file (default: output.dat)")
    ap.add_argument("-o", "--output", default="orbits.png",
                    help="output image (default: orbits.png)")
    ap.add_argument("--min-cols", type=int, default=7,
                    help="minimum number of columns for a line to count as data; "
                         "earlier lines are skipped (default: 7)")
    ap.add_argument("--show", action="store_true",
                    help="show an interactive window in addition to saving")
    ap.add_argument("--dpi", type=int, default=200)
    args = ap.parse_args()

    import matplotlib
    if not args.show:
        matplotlib.use("Agg")  # no window: also works without a graphical environment
    import matplotlib.pyplot as plt

    t, pos = load(args.file, args.min_cols)
    n = pos.shape[1]
    colors = plt.cm.tab10(np.arange(n) % 10)

    # Planar motion (constant z): the XY panel is enough
    extent = np.ptp(pos.reshape(-1, 3), axis=0).max()
    planar = np.ptp(pos[:, :, 2]) < 1e-9 * max(extent, 1e-300)

    static_plot(t, pos, planar, colors, args, plt)

    if args.show:
        plt.show()


if __name__ == "__main__":
    main()
