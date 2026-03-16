#!/bin/bash
# check-review-complete.sh
# Blokkeert PR creatie als er nog CRITICAL of HIGH bevindingen open staan in de task doc.
# Wordt aangeroepen als PreToolUse hook bij `gh pr create`.
# Vindt de juiste task doc op basis van de huidige branch (branch-based scoping).
# Zoekt alleen in de "## Review bevindingen" sectie om false positives te voorkomen.

set -euo pipefail

# Bepaal huidige branch
CURRENT_BRANCH=$(git branch --show-current)

if [ -z "$CURRENT_BRANCH" ]; then
  echo "Kan huidige branch niet bepalen — PR mag aangemaakt worden."
  exit 0
fi

# Zoek het task doc dat bij deze branch hoort via Branch: veld
TASK_DOC=$(grep -rl "Branch: .*${CURRENT_BRANCH}" docs/work/ 2>/dev/null | head -1)

if [ -z "$TASK_DOC" ]; then
  echo "Geen task doc gevonden voor branch ${CURRENT_BRANCH} — PR mag aangemaakt worden."
  exit 0
fi

# Extraheer alleen de "## Review bevindingen" sectie (tot de volgende ## header)
REVIEW_SECTION=$(sed -n '/^## Review bevindingen/,/^## [^#]/p' "$TASK_DOC" 2>/dev/null | head -n -1)

if [ -z "$REVIEW_SECTION" ]; then
  echo "Geen Review bevindingen sectie gevonden in $TASK_DOC — PR mag aangemaakt worden."
  exit 0
fi

# Tel CRITICAL/HIGH bevindingen in de review sectie
# Patroon: bevindingen bevatten severity prefix zoals [SECURITY] CRITICAL, [CODE] HIGH, etc.
CRITICAL_COUNT=$(echo "$REVIEW_SECTION" | grep -c "\] CRITICAL" 2>/dev/null || true)
HIGH_COUNT=$(echo "$REVIEW_SECTION" | grep -c "\] HIGH" 2>/dev/null || true)

# Tel opgeloste bevindingen (doorgestreept, checkmark, of status markers)
FIXED_CRITICAL=$(echo "$REVIEW_SECTION" | grep -c "\] CRITICAL.*FIXED\|~~.*CRITICAL.*~~\|✅.*CRITICAL" 2>/dev/null || true)
FIXED_HIGH=$(echo "$REVIEW_SECTION" | grep -c "\] HIGH.*FIXED\|~~.*HIGH.*~~\|✅.*HIGH" 2>/dev/null || true)

# Tel geaccepteerde bevindingen
ACCEPTED_CRITICAL=$(echo "$REVIEW_SECTION" | grep -c "\] CRITICAL.*ACCEPTED" 2>/dev/null || true)
ACCEPTED_HIGH=$(echo "$REVIEW_SECTION" | grep -c "\] HIGH.*ACCEPTED" 2>/dev/null || true)

OPEN_CRITICAL=$((CRITICAL_COUNT - FIXED_CRITICAL - ACCEPTED_CRITICAL))
OPEN_HIGH=$((HIGH_COUNT - FIXED_HIGH - ACCEPTED_HIGH))

# Zorg dat we niet negatief gaan door edge cases
[ "$OPEN_CRITICAL" -lt 0 ] && OPEN_CRITICAL=0
[ "$OPEN_HIGH" -lt 0 ] && OPEN_HIGH=0

if [ "$OPEN_CRITICAL" -gt 0 ] || [ "$OPEN_HIGH" -gt 0 ]; then
  echo "GEBLOKKEERD: Er zijn nog open bevindingen in $TASK_DOC:"
  echo "  - CRITICAL: $OPEN_CRITICAL open"
  echo "  - HIGH: $OPEN_HIGH open"
  echo ""
  echo "Los alle CRITICAL en HIGH bevindingen op voordat je een PR aanmaakt."
  echo "Markeer opgeloste bevindingen met FIXED of ACCEPTED status."
  exit 2
fi

echo "Alle CRITICAL/HIGH bevindingen zijn opgelost. PR mag aangemaakt worden."
exit 0
