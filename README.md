# MCAD-RPD

## Overzicht

Deze repository bevat de source voor MCAD-RPD, een kleine analyse van de Marine Cyber Attack Database (MCAD) gemaakt in R, DuckDB en Python.

## Installatie

Voer de volgende commands uit:
```bash
Rscript renv.r

python -m venv .venv

source .venv/bin/activate

pip install -r requirements.txt
```
## Gebruik

Data verwerken:
```bash
Rscript src/main.r
```

Data bekijken:
```bash
python src/display.py
```
