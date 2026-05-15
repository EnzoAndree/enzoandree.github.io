#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

MAIN="cv-llt.tex"
OUTPUT="Enzo_Guerrero-Araya_CV.pdf"

if command -v latexmk >/dev/null 2>&1; then
  latexmk -pdf -interaction=nonstopmode -halt-on-error "$MAIN"
elif command -v xelatex >/dev/null 2>&1; then
  xelatex -interaction=nonstopmode -halt-on-error "$MAIN"
  bibtex "${MAIN%.tex}" || true
  xelatex -interaction=nonstopmode -halt-on-error "$MAIN"
  xelatex -interaction=nonstopmode -halt-on-error "$MAIN"
elif command -v lualatex >/dev/null 2>&1; then
  lualatex -interaction=nonstopmode -halt-on-error "$MAIN"
  bibtex "${MAIN%.tex}" || true
  lualatex -interaction=nonstopmode -halt-on-error "$MAIN"
  lualatex -interaction=nonstopmode -halt-on-error "$MAIN"
elif command -v pdflatex >/dev/null 2>&1; then
  pdflatex -interaction=nonstopmode -halt-on-error "$MAIN"
  bibtex "${MAIN%.tex}" || true
  pdflatex -interaction=nonstopmode -halt-on-error "$MAIN"
  pdflatex -interaction=nonstopmode -halt-on-error "$MAIN"
elif command -v tectonic >/dev/null 2>&1; then
  tectonic "$MAIN"
else
  echo "No LaTeX engine found. Install MacTeX/TeX Live or Tectonic, then rerun this script." >&2
  exit 127
fi

if [[ -f "cv-llt.pdf" ]]; then
  cp "cv-llt.pdf" "$OUTPUT"
  echo "Built $ROOT_DIR/$OUTPUT"
else
  echo "Build completed, but cv-llt.pdf was not produced." >&2
  exit 1
fi
