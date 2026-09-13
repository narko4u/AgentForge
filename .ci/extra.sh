#!/usr/bin/env bash
# Bridge-repo checks (run by .github/scripts/validate.py)
set -euo pipefail

test -s README.md || { echo "README.md is empty"; exit 1; }
grep -qi "AgentForge" README.md || { echo "README.md does not name the product"; exit 1; }

if grep -nE "github\.com/(empirelabs-au|narko4u)/[A-Za-z0-9._-]*[Cc]ore" README.md; then
  echo "README links to a private source repository - keep the source unlinked"
  exit 1
fi

echo "public bridge README OK"
