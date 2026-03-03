FROM python:3.11-slim

WORKDIR /app

# Install system dependencies for spaCy, Selenium, and lxml
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy pre-downloaded models so they don't need to be fetched at runtime
COPY models/ ./models/

COPY src/ ./src/
COPY config/config.yaml.example ./config/config.yaml
COPY main.py .

CMD ["python", "main.py"]
