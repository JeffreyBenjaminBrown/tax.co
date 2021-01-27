# PITFALL: This code builds on that in ./main.py;
# for instance, hh is used here but defined there.

import matplotlib
import matplotlib.pyplot as plt
import numpy as np


hh["to plot"] = noisyQuantile(
    10, 0, 0.01,
    hh["months to save for a month"] )

# Inactive: plots
fig, ax = plt.subplots()
ax = hh['to plot'].value_counts().plot(
    kind='bar',
    figsize=(14,8),
    title="title")
ax.set_xlabel("xlabel")
ax.set_ylabel("ylabel")

plt.savefig("temp.png")

##### ??? ####

plt.close()
labels = ['G1', 'G2', 'G3', 'G4', 'G5']
men_means = [20, 34, 30, 35, 27]
women_means = [25, 32, 34, 20, 25]

x = np.arange(len(labels))  # the label locations
width = 0.35  # the width of the bars

fig, ax = plt.subplots()
rects1 = ax.bar(x - width/2, men_means, width, label='Men')
rects2 = ax.bar(x + width/2, women_means, width, label='Women')

# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_ylabel('Scores')
ax.set_title('Scores by group and gender')
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend()


def autolabel(rects):
    """Attach a text label above each bar in *rects*, displaying its height."""
    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),  # 3 points vertical offset
                    textcoords="offset points",
                    ha='center', va='bottom')


autolabel(rects1)
autolabel(rects2)

fig.tight_layout()

plt.savefig("temp.png")
