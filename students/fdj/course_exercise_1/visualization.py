#!/usr/bin/env python3
# compare_output.py: compara output.dat (tipos derivados) con output_original.dat (arrays)
# formato de ambos: t p1a p1b p1c ... pna pnb pnc
import sys
import numpy as np
import matplotlib.pyplot as plt

f_new = sys.argv[1] if len(sys.argv) > 1 else "output.dat"
f_old = sys.argv[2] if len(sys.argv) > 2 else "output_original.dat"


def load(fname):
    data = np.loadtxt(fname, ndmin=2)
    t = data[:, 0]
    pos = data[:, 1:].reshape(len(t), -1, 3)   # (instantes, partículas, componente)
    return t, pos


t1, p1 = load(f_new)
t2, p2 = load(f_old)
n = p1.shape[1]
print(f"nuevo:    {len(t1)} instantes, {p1.shape[1]} partículas, t = {t1[0]} .. {t1[-1]}")
print(f"original: {len(t2)} instantes, {p2.shape[1]} partículas, t = {t2[0]} .. {t2[-1]}")

if p1.shape == p2.shape:
    diff = np.linalg.norm(p1 - p2, axis=2)
    print(f"diferencia máxima: {diff.max():.3e}   (final: {diff[-1].max():.3e})")
else:
    print("Aviso: dimensiones distintas, solo se comparan visualmente.")

colors = plt.rcParams["axes.prop_cycle"].by_key()["color"]
ls_old, ls_new = "-", "--"     # estilo de línea por simulación

fig = plt.figure(figsize=(12, 5))

# Proyección XY
ax1 = fig.add_subplot(1, 2, 1)
for i in range(n):
    c = colors[i % len(colors)]
    ax1.plot(p2[:, i, 0], p2[:, i, 1], ls_old, lw=1.5, color=c,
             label=f"partícula {i+1}" if n <= 10 else None)
    ax1.plot(p1[:, i, 0], p1[:, i, 1], ls_new, lw=1.5, color=c)
    ax1.plot(*p2[0, i, :2], "o", color=c)    # inicio
    ax1.plot(*p2[-1, i, :2], "s", color=c)   # final
ax1.set_xlabel("a (x)"); ax1.set_ylabel("b (y)")
ax1.set_aspect("equal"); ax1.set_title("Proyección XY (○ inicio, □ final)")

# Leyenda: color = partícula, tipo de línea = simulación
if n <= 10:
    handles, labels = ax1.get_legend_handles_labels()
    handles += [plt.Line2D([], [], color="k", ls=ls_old),
                plt.Line2D([], [], color="k", ls=ls_new)]
    labels += ["original", "nuevo"]
    ax1.legend(handles, labels, fontsize=8)

# 3D
ax2 = fig.add_subplot(1, 2, 2, projection="3d")
for i in range(n):
    c = colors[i % len(colors)]
    ax2.plot(p2[:, i, 0], p2[:, i, 1], p2[:, i, 2], ls_old, lw=1.5, color=c)
    ax2.plot(p1[:, i, 0], p1[:, i, 1], p1[:, i, 2], ls_new, lw=1.5, color=c)
ax2.set_xlabel("a"); ax2.set_ylabel("b"); ax2.set_zlabel("c")
ax2.set_title("Trayectorias 3D (continua: original, discontinua: nuevo)")

plt.tight_layout()
plt.show()