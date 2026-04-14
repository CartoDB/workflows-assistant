#!/usr/bin/env bash
# Install dependencies for the render-workflow-diagram skill
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing render-workflow-diagram dependencies..."
cd "$SKILL_DIR"
npm install --no-save --silent 2>&1
echo "Done. You can now render workflows with:"
echo "  node ${SKILL_DIR}/render-workflow.mjs <workflow.json>"
