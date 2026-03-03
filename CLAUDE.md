# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Environment

- Python 3.14 via `.venv/` (project-local virtual environment)
- IDE: PyCharm (Black formatter configured)

Activate the venv before running anything:
```bash
source .venv/bin/activate
```

## Common commands

```bash
# Run the application
python main.py

# Install a package and keep dependencies tracked
pip install <package> && pip freeze > requirements.txt

# Install from requirements file
pip install -r requirements.txt
```

## Project structure

```
data/
  raw/        # Unprocessed API/scraping output (tweets_raw.csv, reddit_raw.json, …)
  processed/  # Cleaned, lemmatized, language-filtered datasets
  external/   # Kaggle corpora: Sentiment140, Reddit dumps
models/       # Downloaded BERT/SBERT weights and quantized ONNX files
src/
  collection/     # Twitter/Reddit API clients, Selenium scraper
  preprocessing/  # Cleaning, language filtering (langdetect), spaCy lemmatizer
  analysis/       # VADER and BERT sentiment analysis
  clustering/     # SBERT vectorization, KMeans / DBSCAN
  visualization/  # Matplotlib plots, t-SNE, WordCloud
notebooks/    # Jupyter experiments (elbow method k=4…12, etc.)
output/       # Final charts and figures for the thesis
config/       # config.yaml (local, gitignored) — copy from config.yaml.example
```

`data/`, `models/`, and `output/` contents are gitignored (large files). Only `.gitkeep` markers are tracked.

## Config

Copy the template and fill in API keys before running:
```bash
cp config/config.yaml.example config/config.yaml
```

## Docker

```bash
docker build -t szakdolgozat .
docker run --rm -v $(pwd)/config/config.yaml:/app/config/config.yaml szakdolgozat
```

## Git workflow

- Commit locally with a clean, descriptive message, then push to `origin/main`
- Commit message format: short imperative subject line, followed by a bullet-point body explaining what changed and why
- Remote: https://github.com/realpeoplerealproblem/szakdolgozat (private)
