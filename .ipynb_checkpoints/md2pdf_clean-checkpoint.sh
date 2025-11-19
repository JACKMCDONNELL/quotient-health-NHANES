#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 input.md"
  exit 1
fi

input="$1"

# strip .md extension for base name
base="${input%.md}"

tex="${base}.tex"
pdf="${base}.pdf"

echo ">>> Converting $input to LaTeX..."
pandoc "$input" -f markdown -t latex -s -o "$tex"

echo ">>> Cleaning alt= attributes that break LaTeX..."
# remove alt={...} from \includegraphics options
perl -pi -e 's/alt=\{[^}]*\}//g' "$tex"
# clean up stray commas before closing brackets, e.g. [keepaspectratio,]
perl -pi -e 's/,\]/]/g' "$tex"

echo ">>> Running XeLaTeX..."
xelatex "$tex" >/dev/null 2>&1
xelatex "$tex" >/dev/null 2>&1

echo ">>> Done. Output: $pdf"

