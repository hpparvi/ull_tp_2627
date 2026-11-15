import sys
import numpy as np
import matplotlib.pyplot as plt

if len(sys.argv) < 4:
    print(
        "Usage: python3 plot_results.py <initial_input.dat> <output.dat> <energy.dat>"
    )
    sys.exit(1)

init_file, out_file, energy_file = sys.argv[1], sys.argv[2], sys.argv[3]

# 1. Read initial state (skip first 4 parameter lines: dt, dt_out, t_end, n)
init_data = np.loadtxt(init_file, skiprows=4)
x0, y0, z0 = init_data[:, 1], init_data[:, 2], init_data[:, 3]

# 2. Read final state (last row of output.dat)
with open(out_file, "r") as f:
    lines = [line.strip() for line in f if line.strip()]
last_row = np.fromstring(lines[-1], sep=" ")
t_final = last_row[0]
coords_final = last_row[1:].reshape(-1, 3)
xf, yf, zf = coords_final[:, 0], coords_final[:, 1], coords_final[:, 2]

# 3. Plot 3D Initial vs Final Snapshots
fig = plt.figure(figsize=(12, 5.5))
ax1 = fig.add_subplot(121, projection="3d")
ax1.scatter(x0, y0, z0, s=2, alpha=0.6, c="royalblue")
ax1.set_title("Initial State (t = 0.0)")
ax1.set_xlabel("X")
ax1.set_ylabel("Y")
ax1.set_zlabel("Z")

ax2 = fig.add_subplot(122, projection="3d")
ax2.scatter(xf, yf, zf, s=2, alpha=0.6, c="crimson")
ax2.set_title(f"Final State (t = {t_final:.3f})")
ax2.set_xlabel("X")
ax2.set_ylabel("Y")
ax2.set_zlabel("Z")

plt.tight_layout()
plt.savefig("snapshots.png", dpi=300)

# 4. Read and Plot Energy Diagnostics
e_data = np.loadtxt(energy_file, comments="#")
t, e_kin, e_pot, e_tot, rel_err = (
    e_data[:, 0],
    e_data[:, 1],
    e_data[:, 2],
    e_data[:, 3],
    e_data[:, 4],
)

fig2, (ax_e, ax_err) = plt.subplots(2, 1, figsize=(8, 6), sharex=True)
ax_e.plot(t, e_kin, label="Kinetic ($E_{kin}$)", color="tab:orange")
ax_e.plot(t, e_pot, label="Potential ($E_{pot}$)", color="tab:blue")
ax_e.plot(t, e_tot, label="Total ($E_{tot}$)", color="black", linewidth=2)
ax_e.set_ylabel("Energy")
ax_e.set_title("Mechanical Energy Conservation")
ax_e.legend()
ax_e.grid(True, alpha=0.3)

ax_err.plot(t, rel_err, color="tab:red", marker="o", markersize=3)
ax_err.set_xlabel("Time")
ax_err.set_ylabel("Relative Error $\\Delta E / |E_0|$")
ax_err.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig("energy_plot.png", dpi=300)
plt.show()
