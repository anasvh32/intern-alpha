#!/bin/bash
set -euo pipefail

write_gitignore() {
cat > .gitignore <<EOT
.venv/
__pycache__/
.env
EOT
}

write_gitignore
git add -A
git commit -q -m "$msg"
git push -q origin main
echo "saved week-$week/day-$day"