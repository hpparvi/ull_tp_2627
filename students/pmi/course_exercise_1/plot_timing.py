import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.ticker import NullLocator


N_threads = [1, 2, 4, 8]

times = {
    1000:  [1.83,  1.38,  0.81,  0.4800],
    2000:  [7.34,  5.54,  3.24,  2.4010],
    5000:  [26.50, 22.01, 14.00, 9.7450],
    10000: [96.22, 73.67, 45.36, 28.6050],
}

ns = list(times)





fig, ax = plt.subplots(figsize=(6, 4.5))
for n in ns:
    ax.plot(N_threads, times[n], "o-", label=f"n = {n}")
ax.set_xscale("log")#, base=2)
ax.set_yscale("log")
ax.set_xticks(N_threads, labels=[str(t) for t in N_threads])
ax.xaxis.set_minor_locator(NullLocator())
ax.set_xlabel("NUM_THREADS")
ax.set_ylabel("Time (s)")
ax.set_title("Time vs number of threads")
ax.grid(alpha=0.3, which="both")
ax.legend()
fig.tight_layout()
fig.savefig("t_Nthreads.png", dpi=200)
plt.close(fig)






fig, ax = plt.subplots(figsize=(6, 4.5))
for k, th in enumerate(N_threads):
    ax.plot(ns, [times[n][k] for n in ns], "o-",
            label=f"{th} thread" + ("s" if th > 1 else ""))
ax.set_xscale("log")
ax.set_yscale("log")
ax.set_xticks(ns, labels=[str(n) for n in ns])
ax.xaxis.set_minor_locator(NullLocator())
ax.set_xlabel("n")
ax.set_ylabel("Time (s)")
ax.set_title("Time vs number of particles")
ax.grid(alpha=0.3, which="both")
ax.legend()
fig.tight_layout()
fig.savefig("t_n.png", dpi=200)
plt.close(fig)

