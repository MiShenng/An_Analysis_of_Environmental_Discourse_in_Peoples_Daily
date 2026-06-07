# Source Inventory

This folder was assembled from local project files to match the repository README structure.

## Included

- `data/processed/coded_metadata.xlsx`: processed article-level coding table without full article body text.
- `data/processed/README.md`: data availability note for processed materials.
- `data/raw/README.md`: note explaining that raw materials remain local-only.
- `scripts/crawler/`: People’s Daily crawler scripts.
- `scripts/content_analysis/llm_content_coding.R`: LLM-assisted content-coding script. API credentials were removed; set `DASHSCOPE_API_KEY` in the environment before running.
- `scripts/discourse_analysis/`: R scripts for diachronic and discourse-oriented summaries.
- `results/tables/`: aggregate tables generated from coded metadata.
- `results/figures/`: existing project figures.
- `docs/manuscript/`: manuscript PDF, reviewed Word draft, and complete LaTeX bundle with `main.tex`, `body.tex`, `charts/`, and `media/`.

## Excluded

- Public Git tracking for raw People’s Daily full-text article files.
- Public Git tracking for raw or semi-raw spreadsheets containing `文本内容` or `正文` columns.
- Public Git tracking for raw article body text and raw full-text spreadsheets.
- Social media raw platform data.
- Local Word/LaTeX manuscript build files and editor/session artifacts.
- Any hard-coded API keys or local credentials.

## Notes

The public repository documents methods, processed coding labels, and aggregate results while avoiding redistribution of copyrighted article text or platform content.
