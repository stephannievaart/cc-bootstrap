#!/bin/bash
# session-end-reminder.sh
# Herinnert aan WIP commit en signaleert verouderde worktrees.
# Wordt aangeroepen als Stop hook bij het einde van een sessie.

set -euo pipefail

# Platform-specifieke notificatie functie
notify() {
  local message="$1"
  if command -v osascript &>/dev/null; then
    osascript -e "display notification \"$message\" with title \"Claude Code\"" 2>/dev/null || true
  elif command -v notify-send &>/dev/null; then
    notify-send "Claude Code" "$message" 2>/dev/null || true
  fi
}

echo "=== Sessie einde check ==="

# Check op uncommitted changes
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
  echo ""
  echo "⚠ WAARSCHUWING: Er zijn uncommitted wijzigingen."
  echo "Overweeg een WIP commit:"
  echo "  git add -A && git commit -m 'WIP: [beschrijving]'"
fi

# Check op untracked files (exclusief .claude/ en node_modules/)
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | grep -v "^\.claude/" | grep -v "^node_modules/" | head -5 || true)
if [ -n "$UNTRACKED" ]; then
  echo ""
  echo "⚠ Untracked bestanden gevonden:"
  echo "$UNTRACKED"
  echo "  (en mogelijk meer...)"
fi

# Check op gemerged worktrees die opgeruimd kunnen worden
REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "")
if [ -n "$REPO_NAME" ]; then
  MERGED_BRANCHES=$(git branch --merged main 2>/dev/null | grep -v "^\*\|main\|master" | sed 's/^[[:space:]]*//' || true)
  if [ -n "$MERGED_BRANCHES" ]; then
    for BRANCH in $MERGED_BRANCHES; do
      WORKTREE_PATH="../${REPO_NAME}--${BRANCH//\//-}"
      if [ -d "$WORKTREE_PATH" ]; then
        echo ""
        echo "⚠ Worktree voor gemerged branch gevonden: $WORKTREE_PATH"
        echo "  Opruimen met: git worktree remove $WORKTREE_PATH && git worktree prune"
      fi
    done
  fi
fi

echo ""
echo "=== Check compleet ==="
exit 0
