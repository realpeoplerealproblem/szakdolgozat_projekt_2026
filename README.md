# ChatGPT Sentiment Analysis Pipeline

Automatizált pipeline Reddit-bejegyzések hangulatelemzésére és témakör-klaszterezésére. A rendszer többféle modellt támogat (VADER, DistilBERT, RoBERTa, DeBERTa, XLNet, ensemble), és kész statisztikákat, ábrákat generál.

## Telepítés

```bash
git clone https://github.com/realpeoplerealproblem/szakdolgozat_projekt_2026.git
cd szakdolgozat_projekt_2026

python3 -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate

pip install -r requirements.txt
```

## Konfiguráció

```bash
cp config/config.yaml.example config/config.yaml
# Töltsd ki az API-kulcsokat (csak API-alapú gyűjtéshez szükséges)
```

## BERT modell előkészítése (ensemble módhoz)

A `bert_sentiment.onnx` fájl mérete meghaladja a GitHub feltöltési korlátját, ezért azt az első futtatás előtt lokálisan kell legenerálni:

```bash
python scripts/export_onnx.py
```

Ez letölti a modellt a HuggingFace-ről, és kvantált ONNX formátumba exportálja (`models/bert_sentiment.onnx`). Internetkapcsolat és ~2 GB szabad tárhely szükséges.

A metamodell (logisztikus regressziós döntőbíró) tanítása:

```bash
# Kézi annotálással (ajánlott)
python scripts/train_metamodel.py --export_sample
# → töltsd ki a data/external/label_sample.csv true_label oszlopát
python scripts/train_metamodel.py --input data/external/label_sample.csv
```

## Futtatás

```bash
# Alaplefutás (VADER, leggyorsabb)
python main.py

# Transzformer-alapú elemzés
python main.py --sentiment_model roberta
python main.py --sentiment_model distilbert
python main.py --sentiment_model deberta

# Ensemble (VADER + BERT ONNX + metamodell)
python main.py --sentiment_model ensemble

# Friss adatok gyűjtésével
python main.py --scrape --sentiment_model roberta

# Klaszterszám kézi megadásával
python main.py --k_clusters 8

# Modellek összehasonlítása (Sentiment140 benchmark)
python main.py --evaluate
```

## Kimenet

```
reports/figures/    ← PNG ábrák (hangulatmegoszlás, klasztertérkép, szófelhők)
reports/model_comparison.csv  ← modellek összehasonlítása
data/processed/chatgpt_clustered.csv  ← teljes elemzett adathalmaz
```

## Docker

```bash
docker build -t szakdolgozat .
docker run --rm \
  -v $(pwd)/config/config.yaml:/app/config/config.yaml \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/models:/app/models \
  -v $(pwd)/reports:/app/reports \
  szakdolgozat
```
