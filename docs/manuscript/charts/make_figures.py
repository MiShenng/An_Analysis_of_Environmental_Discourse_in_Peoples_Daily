"""Rebuild the 6 lost Office charts as publication-quality vector PDFs.

Data source: chart_data.json (extracted from the .docx embedded chart XML).
Output: charts/fig_chartN.pdf  (vector, Songti SC, colorblind-safe palette).
"""
import json
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib import rcParams

HERE = Path(__file__).resolve().parent
DATA = json.load(open(HERE / "chart_data.json", encoding="utf-8"))

# Chinese font (matches document main CJK font), keep minus sign correct.
rcParams["font.sans-serif"] = ["Songti SC"]
rcParams["font.family"] = "sans-serif"
rcParams["axes.unicode_minus"] = False
rcParams["pdf.fonttype"] = 42  # embed TrueType, selectable text
rcParams["savefig.bbox"] = "tight"

# Okabe-Ito colorblind-safe palette.
OKABE = ["#0072B2", "#E69F00", "#009E73", "#D55E00",
         "#CC79A7", "#56B4E9", "#F0E442", "#000000"]


def fnum(values):
    return [float(v) for v in values]


def strip(s):
    return s.strip()


def save(fig, name):
    out = HERE / f"{name}.pdf"
    fig.savefig(out)
    plt.close(fig)
    print(f"wrote {out}")


def line_year(chart, name, every=10):
    """Single-series yearly line chart (chart1)."""
    c = DATA[chart]
    years = [int(y) for y in c["categories"]]
    vals = fnum(c["series"][0]["values"])
    fig, ax = plt.subplots(figsize=(7.2, 3.6))
    ax.plot(years, vals, color=OKABE[0], linewidth=1.6)
    ax.fill_between(years, vals, color=OKABE[0], alpha=0.12)
    ax.set_xlabel("年份")
    ax.set_ylabel("报道数量（篇）")
    ax.set_xticks([y for y in years if y % every == 0])
    ax.margins(x=0.01)
    ax.grid(axis="y", linestyle=":", linewidth=0.6, alpha=0.6)
    for sp in ["top", "right"]:
        ax.spines[sp].set_visible(False)
    save(fig, name)


def bar(chart, name, horizontal=True):
    c = DATA[chart]
    cats = [strip(x) for x in c["categories"]]
    vals = fnum(c["series"][0]["values"])
    pairs = sorted(zip(cats, vals), key=lambda t: t[1], reverse=True)
    cats, vals = [p[0] for p in pairs], [p[1] for p in pairs]
    fig, ax = plt.subplots(figsize=(6.6, 3.8))
    if horizontal:
        cats, vals = cats[::-1], vals[::-1]
        bars = ax.barh(cats, vals, color=OKABE[0], height=0.62)
        ax.set_xlabel("篇数")
        for b, v in zip(bars, vals):
            ax.text(b.get_width() + max(vals) * 0.01,
                    b.get_y() + b.get_height() / 2,
                    f"{int(v)}", va="center", fontsize=9)
        ax.margins(x=0.12)
    else:
        bars = ax.bar(cats, vals, color=OKABE[0], width=0.62)
        ax.set_ylabel("篇数")
    for sp in ["top", "right"]:
        ax.spines[sp].set_visible(False)
    ax.grid(axis="x" if horizontal else "y", linestyle=":", linewidth=0.6, alpha=0.6)
    save(fig, name)


def pie(chart, name):
    c = DATA[chart]
    cats = [strip(x) for x in c["categories"]]
    vals = fnum(c["series"][0]["values"])
    fig, ax = plt.subplots(figsize=(4.8, 4.2))
    wedges, _texts, autotexts = ax.pie(
        vals, labels=cats, colors=OKABE[: len(vals)],
        autopct=lambda p: f"{p:.1f}%", startangle=90,
        wedgeprops=dict(width=1.0, edgecolor="white", linewidth=1.2),
        pctdistance=0.7,
    )
    for t in autotexts:
        t.set_color("white")
        t.set_fontsize(10)
    ax.set_aspect("equal")
    save(fig, name)


def multiline_year(chart, name, every=10):
    """Multi-series yearly line chart (chart5: 6 frames)."""
    c = DATA[chart]
    years = [int(y) for y in c["categories"]]
    fig, ax = plt.subplots(figsize=(7.4, 4.0))
    for i, s in enumerate(c["series"]):
        ax.plot(years, fnum(s["values"]), color=OKABE[i % len(OKABE)],
                linewidth=1.3, label=strip(s["name"]))
    ax.set_xlabel("年份")
    ax.set_ylabel("框架出现频次")
    ax.set_xticks([y for y in years if y % every == 0])
    ax.margins(x=0.01)
    ax.grid(axis="y", linestyle=":", linewidth=0.6, alpha=0.6)
    for sp in ["top", "right"]:
        ax.spines[sp].set_visible(False)
    ax.legend(loc="upper left", fontsize=8, frameon=False, ncol=2)
    save(fig, name)


if __name__ == "__main__":
    line_year("chart1", "fig_chart1")        # 环境新闻报道随时间发展趋势
    bar("chart2", "fig_chart2")              # 报道体裁分布
    bar("chart3", "fig_chart3")              # 信源分布
    pie("chart4", "fig_chart4")              # 软硬新闻比例
    multiline_year("chart5", "fig_chart5")   # 框架逐年分布
    pie("chart6", "fig_chart6")              # 情感倾向占比
    print("done")
