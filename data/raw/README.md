# Raw Data

This directory is for local raw materials only. Raw files are ignored by Git through `github_ready/.gitignore`; this README is kept so the repository documents where raw materials fit in the workflow.

## Spreadsheets

- `spreadsheets/coded_records_with_article_text.xlsx`: coded records with article text.
- `spreadsheets/raw_people_daily_text_index.csv`: raw People’s Daily text index.
- `spreadsheets/raw_before72.xlsx`: pre-1972 raw/intermediate table.
- `spreadsheets/raw_after72.xlsx`: post-1972 raw/intermediate table.

## Articles

- `articles/people_daily_1949_2024/`: partial local copy of the full article corpus.
- `articles/people_daily_1949_2024_source`: symbolic link to the complete local source directory.

The complete source directory is about 89GB. The partial copy in `articles/people_daily_1949_2024/` was stopped after reaching about 25GB to avoid making the GitHub-ready folder too large.
