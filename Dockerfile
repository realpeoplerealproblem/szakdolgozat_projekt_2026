# ── Base ──────────────────────────────────────────────────────────────────────
FROM python:3.11-slim

# Prevent Python from writing .pyc files and enable unbuffered stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# ── System dependencies ───────────────────────────────────────────────────────
# - gcc / g++      : required to compile some Python C-extensions (e.g. blis)
# - chromium       : headless browser for Selenium scraping
# - chromium-driver: matching ChromeDriver (same package version as Chromium)
# - libgomp1       : OpenMP runtime needed by ONNX Runtime
# Clean up apt cache in the same layer to keep the image small
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        g++ \
        chromium \
        chromium-driver \
        libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Tell Selenium where to find the Chromium binary
ENV CHROME_BIN=/usr/bin/chromium

# ── Python dependencies ───────────────────────────────────────────────────────
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ── NLP model downloads (baked into the image at build time) ──────────────────
RUN python -m spacy download en_core_web_sm
RUN python -m nltk.downloader vader_lexicon

# ── Project files ─────────────────────────────────────────────────────────────
COPY src/        ./src/
COPY data/       ./data/
COPY models/     ./models/
COPY notebooks/  ./notebooks/
COPY output/     ./output/
COPY config/config.yaml.example ./config/config.yaml
COPY main.py     .

# ── Entrypoint ────────────────────────────────────────────────────────────────
CMD ["python", "main.py"]
