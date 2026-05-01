#!/usr/bin/env bash
#
# rebrand_to_odysee.sh
# ====================
# One-shot rebrand of the tco repo: t.Co. / Tico → Odysee
#
# Usage:
#   cd ~/Desktop/tco-fresh
#   bash rebrand_to_odysee.sh --dry-run     # preview changes, no writes
#   bash rebrand_to_odysee.sh --apply       # perform the rebrand
#   bash rebrand_to_odysee.sh --rollback    # revert from backup
#
# What it does:
#   1. Creates a timestamped backup of the entire repo
#   2. Replaces brand strings across HTML, CSS, JS, MD files
#   3. Renames files containing "tco_" in their names
#   4. Reports every change
#
# What it does NOT touch:
#   - Binary files (PDF, DOCX, XLSX, images)  → regenerate separately
#   - .git directory                           → safe
#   - node_modules if present                  → safe
#   - GitHub repo name itself                  → manual rename via GitHub UI
#   - The domain (tico.mytico.me → odysee.me)  → DNS change, not file change
#

set -euo pipefail

# --- Configuration -----------------------------------------------------------

MODE="${1:-}"
REPO_ROOT="$(pwd)"
BACKUP_DIR="${REPO_ROOT}/.rebrand-backups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_PATH="${BACKUP_DIR}/backup_${TIMESTAMP}"
LOG_FILE="${REPO_ROOT}/rebrand_${TIMESTAMP}.log"

# File types to process
TEXT_EXTENSIONS=(html htm css js json md txt xml svg yml yaml)

# Directories to skip entirely
SKIP_DIRS=(.git .rebrand-backups node_modules .vscode .idea dist build)

# --- Brand replacement rules -------------------------------------------------
# Order matters: most specific first, so "t.Co." is replaced before stray "Tico".
# These patterns are case-sensitive. Non-matching cases are handled separately.

declare -a REPLACEMENTS=(
  # Brand name — most specific variants first
  "t.Co.|Odysee"
  "t.Co|Odysee"
  "tco_project_book|odysee_project_book"
  "tco_architecture|odysee_architecture"
  "tco_ux-flows|odysee_ux-flows"
  "tco_onboarding|odysee_onboarding"
  "tco_design-system|odysee_design-system"
  "tco-prototype|odysee-prototype"
  "tco-design.css|odysee-design.css"
  "tco-theme|odysee-theme"

  # Note: "Tico" is NOT replaced — Tico is the name of the AI agent.
  # The decision (April 2026): Odysee is the system/product, Tico is the agent persona.
  # This mirrors the Amazon/Alexa, Apple/Siri, Salesforce/Einstein pattern.

  # Domain — careful: only replace the mytico.me references, not arbitrary URLs
  "tico.mytico.me|odysee.me"
  "https://mytico.me/tico|https://odysee.me"
  "mytico.me/tico|odysee.me"
)

# --- Logging helpers ---------------------------------------------------------

log() {
  local level="$1"; shift
  local msg="$*"
  local stamp
  stamp="$(date '+%H:%M:%S')"
  case "$level" in
    INFO)  printf '\033[36m[%s] %s\033[0m\n' "$stamp" "$msg" ;;
    OK)    printf '\033[32m[%s] ✓ %s\033[0m\n' "$stamp" "$msg" ;;
    WARN)  printf '\033[33m[%s] ⚠ %s\033[0m\n' "$stamp" "$msg" ;;
    ERR)   printf '\033[31m[%s] ✗ %s\033[0m\n' "$stamp" "$msg" >&2 ;;
    DRY)   printf '\033[35m[%s] [DRY] %s\033[0m\n' "$stamp" "$msg" ;;
  esac
  echo "[$stamp] [$level] $msg" >> "$LOG_FILE" 2>/dev/null || true
}

# --- Safety checks -----------------------------------------------------------

check_preconditions() {
  if [[ ! -d ".git" ]]; then
    log ERR "Not a git repository. Run this from the repo root (~/Desktop/tco-fresh)."
    exit 1
  fi

  if ! git diff --quiet HEAD 2>/dev/null; then
    log WARN "You have uncommitted changes. Commit or stash them first."
    log WARN "Continue anyway? (y/N)"
    read -r answer
    if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
      log INFO "Aborted."
      exit 0
    fi
  fi

  local current_branch
  current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
  log INFO "Current git branch: $current_branch"

  if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
    log WARN "You are on $current_branch. Consider creating a 'rebrand' branch first:"
    log WARN "   git checkout -b rebrand"
    log WARN "Continue on $current_branch? (y/N)"
    read -r answer
    if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
      log INFO "Aborted. Create a branch and re-run."
      exit 0
    fi
  fi
}

# --- Backup ------------------------------------------------------------------

create_backup() {
  log INFO "Creating backup at $BACKUP_PATH"
  mkdir -p "$BACKUP_DIR"

  local skip_args=()
  for d in "${SKIP_DIRS[@]}"; do
    skip_args+=(--exclude="$d")
  done

  if command -v rsync >/dev/null 2>&1; then
    rsync -a "${skip_args[@]}" "$REPO_ROOT/" "$BACKUP_PATH/"
  else
    # Fallback: tar approach
    mkdir -p "$BACKUP_PATH"
    local tar_excludes=()
    for d in "${SKIP_DIRS[@]}"; do
      tar_excludes+=(--exclude="$d")
    done
    tar -cf - "${tar_excludes[@]}" -C "$REPO_ROOT" . | tar -xf - -C "$BACKUP_PATH"
  fi

  log OK "Backup created. Size: $(du -sh "$BACKUP_PATH" | cut -f1)"
}

# --- File discovery ----------------------------------------------------------

should_skip_dir() {
  local path="$1"
  for d in "${SKIP_DIRS[@]}"; do
    if [[ "$path" == *"/$d/"* || "$path" == *"/$d" ]]; then
      return 0
    fi
  done
  return 1
}

find_text_files() {
  local find_args=()
  for ext in "${TEXT_EXTENSIONS[@]}"; do
    find_args+=(-iname "*.$ext" -o)
  done
  # remove trailing -o
  unset 'find_args[${#find_args[@]}-1]'

  local skip_args=()
  for d in "${SKIP_DIRS[@]}"; do
    skip_args+=(-not -path "*/$d/*" -not -path "*/$d")
  done

  find "$REPO_ROOT" -type f \( "${find_args[@]}" \) "${skip_args[@]}"
}

# --- Text replacement --------------------------------------------------------

process_file() {
  local file="$1"
  local dry="$2"
  local changed=0
  local tmp
  tmp="$(mktemp)"

  cp "$file" "$tmp"

  local pair pattern replacement
  for pair in "${REPLACEMENTS[@]}"; do
    pattern="${pair%%|*}"
    replacement="${pair#*|}"

    # Use perl for reliable cross-platform replacement (handles macOS + Linux)
    if grep -qF "$pattern" "$tmp" 2>/dev/null; then
      perl -i -pe "s/\\Q${pattern}\\E/${replacement}/g" "$tmp"
      changed=1
    fi
  done

  if [[ "$changed" == "1" ]]; then
    local diff_summary
    diff_summary="$(diff -u "$file" "$tmp" | grep -c '^[+-][^+-]' || true)"

    if [[ "$dry" == "1" ]]; then
      log DRY "$file ($diff_summary lines would change)"
    else
      mv "$tmp" "$file"
      log OK "$file ($diff_summary lines changed)"
    fi
  fi

  rm -f "$tmp"
  return 0
}

# --- File renaming -----------------------------------------------------------

rename_files() {
  local dry="$1"
  local count=0

  # Find files with "tco_" or "tco-" in their basename
  while IFS= read -r -d '' file; do
    local dir base newbase newpath
    dir="$(dirname "$file")"
    base="$(basename "$file")"
    newbase="$base"

    newbase="${newbase//tco_/odysee_}"
    newbase="${newbase//tco-/odysee-}"

    if [[ "$newbase" != "$base" ]]; then
      newpath="$dir/$newbase"
      if [[ "$dry" == "1" ]]; then
        log DRY "RENAME: $file → $newpath"
      else
        if [[ -e "$newpath" ]]; then
          log WARN "Target exists, skipping: $newpath"
        else
          mv "$file" "$newpath"
          log OK "Renamed: $base → $newbase"
          count=$((count + 1))
        fi
      fi
    fi
  done < <(find "$REPO_ROOT" -type f \( -name "*tco_*" -o -name "*tco-*" \) \
           $(printf -- '-not -path */%s/* ' "${SKIP_DIRS[@]}") -print0 2>/dev/null || true)

  log INFO "Files renamed: $count"
}

# --- Main operations ---------------------------------------------------------

run_dry_run() {
  log INFO "=== DRY RUN — no files will be modified ==="
  log INFO ""

  local file_count=0
  local affected_count=0

  while IFS= read -r file; do
    file_count=$((file_count + 1))
    # Check if file contains any of our patterns
    local has_match=0
    for pair in "${REPLACEMENTS[@]}"; do
      local pattern="${pair%%|*}"
      if grep -qF "$pattern" "$file" 2>/dev/null; then
        has_match=1
        break
      fi
    done
    if [[ "$has_match" == "1" ]]; then
      process_file "$file" 1
      affected_count=$((affected_count + 1))
    fi
  done < <(find_text_files)

  log INFO ""
  log INFO "=== Rename preview ==="
  rename_files 1

  log INFO ""
  log INFO "=== Dry run summary ==="
  log INFO "Text files scanned: $file_count"
  log INFO "Text files affected: $affected_count"
  log INFO ""
  log INFO "To apply these changes:"
  log INFO "  bash rebrand_to_odysee.sh --apply"
}

run_apply() {
  log INFO "=== APPLYING REBRAND ==="
  check_preconditions
  create_backup

  local file_count=0
  local affected_count=0

  while IFS= read -r file; do
    file_count=$((file_count + 1))
    local has_match=0
    for pair in "${REPLACEMENTS[@]}"; do
      local pattern="${pair%%|*}"
      if grep -qF "$pattern" "$file" 2>/dev/null; then
        has_match=1
        break
      fi
    done
    if [[ "$has_match" == "1" ]]; then
      process_file "$file" 0
      affected_count=$((affected_count + 1))
    fi
  done < <(find_text_files)

  log INFO ""
  log INFO "=== Renaming files ==="
  rename_files 0

  log INFO ""
  log INFO "=== Rebrand complete ==="
  log INFO "Text files scanned: $file_count"
  log INFO "Text files affected: $affected_count"
  log INFO "Backup location: $BACKUP_PATH"
  log INFO "Log file: $LOG_FILE"
  log INFO ""
  log INFO "Next steps:"
  log INFO "  1. Review changes: git diff"
  log INFO "  2. Preview site locally: open index.html"
  log INFO "  3. Commit: git add -A && git commit -m 'rebrand: t.Co → Odysee'"
  log INFO "  4. If anything broke: bash rebrand_to_odysee.sh --rollback"
  log INFO ""
  log INFO "NOT handled by this script (manual):"
  log INFO "  - PDFs/DOCXs in docs/ (regenerate separately)"
  log INFO "  - GitHub repo rename (dcastiel007/tco → dcastiel007/odysee)"
  log INFO "  - Domain DNS (odysee.me → GitHub Pages)"
}

run_rollback() {
  log INFO "=== ROLLBACK ==="

  if [[ ! -d "$BACKUP_DIR" ]]; then
    log ERR "No backup directory found."
    exit 1
  fi

  local latest
  latest="$(ls -t "$BACKUP_DIR" | head -n1)"

  if [[ -z "$latest" ]]; then
    log ERR "No backups found in $BACKUP_DIR"
    exit 1
  fi

  log WARN "About to restore from: $BACKUP_DIR/$latest"
  log WARN "This will overwrite current files. Continue? (y/N)"
  read -r answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    log INFO "Rollback aborted."
    exit 0
  fi

  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$BACKUP_DIR/$latest/" "$REPO_ROOT/" \
      --exclude='.git' --exclude='.rebrand-backups'
  else
    cp -R "$BACKUP_DIR/$latest/." "$REPO_ROOT/"
  fi

  log OK "Restored from $latest"
}

# --- Entrypoint --------------------------------------------------------------

case "$MODE" in
  --dry-run|-n)
    run_dry_run
    ;;
  --apply|-a)
    run_apply
    ;;
  --rollback|-r)
    run_rollback
    ;;
  ""|--help|-h)
    cat <<EOF
rebrand_to_odysee.sh — t.Co./Tico → Odysee

Usage:
  bash rebrand_to_odysee.sh --dry-run     Preview changes (safe, no writes)
  bash rebrand_to_odysee.sh --apply       Perform the rebrand
  bash rebrand_to_odysee.sh --rollback    Restore from latest backup

Recommended sequence:
  1. git checkout -b rebrand
  2. bash rebrand_to_odysee.sh --dry-run    # review what will change
  3. bash rebrand_to_odysee.sh --apply      # apply
  4. open index.html                        # verify visually
  5. git add -A && git commit -m "rebrand: Odysee"

Run from the repo root: ~/Desktop/tco-fresh
EOF
    ;;
  *)
    log ERR "Unknown option: $MODE"
    log INFO "Run: bash rebrand_to_odysee.sh --help"
    exit 1
    ;;
esac
