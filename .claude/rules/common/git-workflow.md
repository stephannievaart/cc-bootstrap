# Git Workflow Rules

Harde git regels. Voor procedurele details zie: `.claude/skills/git-workflow/SKILL.md`

---

## Branch regels

- Nooit direct committen op `main`
- Alle branches komen van `main` — geen develop branch
- Branch naming: `feature/[naam]`, `bug/[P1|P2|P3]-[naam]`, `chore/[naam]`
- Één task doc = één branch
- Branch direct aanmaken bij capture (lokaal + remote)

## Commit regels

- Commit types: `feat`, `fix`, `chore`, `docs`, `test`, `refactor`
- Format: `[type]: [beschrijving in tegenwoordige tijd]`
- WIP commits bij context switch: `WIP: [huidige staat]`
- WIP commits worden nooit gemerged — squash of amend voor PR
- Nooit pushen zonder tests groen

## PR regels

- Alle acceptance criteria gecheckt ✓ voor PR aanmaken
- Alle review bevindingen hebben status `FIXED` of `ACCEPTED`
- Branch up-to-date met main (rebase voor PR)
- PR beschrijving = task doc inhoud
- Nooit eigen PR mergen zonder review

## Worktree regels

- Eén Claude Code sessie = één worktree = één branch
- Nooit twee sessies in dezelfde working directory
- Nooit `git checkout` naar een branch waarop een actieve sessie draait
- Worktree naming: `[repo-naam]--[branch-naam-met-streepjes]`
- Worktrees altijd opruimen na merge: `git worktree remove` + `git worktree prune`
- CLAUDE.md en `.claude/` altijd als symlink in elke worktree

## Verboden

- `git push --force` op `main`
- `--no-verify` zonder expliciete goedkeuring
- Secrets of `.env` bestanden committen
- Rebasen van gedeelde branches (main)
- `git checkout` terwijl een andere sessie actief is op de doelbranch
