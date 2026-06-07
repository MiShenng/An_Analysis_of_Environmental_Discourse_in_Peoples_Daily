# Source Inventory

This folder was assembled from local project files to match the repository README structure.

## Included

- `data/processed/README.md`: note explaining why row-level processed data are not included.
- `data/raw/README.md`: note explaining that raw materials remain local-only.
- `scripts/crawler/`: People’s Daily crawler scripts.
- `scripts/content_analysis/llm_content_coding.R`: LLM-assisted content-coding script. API credentials were removed; set `DASHSCOPE_API_KEY` in the environment before running.
- `scripts/discourse_analysis/`: R scripts for diachronic and discourse-oriented summaries.
- `results/tables/`: aggregate tables generated from coded metadata.
- `results/figures/`: existing project figures.
- `docs/manuscript/`: manuscript PDF, LaTeX source files, and reviewed Word draft.

## Excluded

- Public Git tracking for raw People’s Daily full-text article files.
- Public Git tracking for raw or semi-raw spreadsheets containing `文本内容` or `正文` columns.
- Public Git tracking for row-level coded metadata containing article titles or other article-level identifiers.
- Social media raw platform data.
- Local Word/LaTeX manuscript build files and editor/session artifacts.
- Any hard-coded API keys or local credentials.

## Notes

The public repository should document methods and aggregate results while avoiding redistribution of copyrighted article text, row-level article records, or platform content.
