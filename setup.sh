#!/bin/bash

# Check for R
if ! command -v Rscript &> /dev/null; then
    echo "Error: R is not installed. Please install R to continue."
    exit 1
fi

# Check for Python 3
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed. Please install Python 3 to continue."
    exit 1
fi

echo "Setting up R environment..."
# Set up renv non-interactively
Rscript -e "if(!requireNamespace('renv', quietly=TRUE)) install.packages('renv', repos='https://cloud.r-project.org')"
Rscript -e "renv::restore(confirm = FALSE)"
Rscript renv.r

echo "Setting up Python environment..."
# Set up venv
python3 -m venv .venv

# Install Python packages
.venv/bin/pip install -r requirements.txt

echo "Setup complete!"
echo "To process data: Rscript src/main.r"
echo "To view data: source .venv/bin/activate && python src/display.py"
