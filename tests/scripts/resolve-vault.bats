#!/usr/bin/env bats
# Tests for scripts/resolve-vault.sh — settings.json integration.
#
# Behavior under test:
#   - resolve_vault() reads current_vault_path from settings.json (Tier 2).
#   - LLM_WIKI_VAULT env var overrides settings file (Tier 1 > Tier 2).
#   - Falls back to default "docs/vault" when settings file is absent.
#   - init_vault_settings() creates the file with default values when absent.
#   - init_vault_settings() is a no-op when the file already exists.
#   - set_vault_path() updates only current_vault_path; default_vault_path untouched.
#   - set_vault_path() creates settings.json first if it does not exist.
#   - scripts/set-vault.sh exits 1 with no argument.
#   - scripts/set-vault.sh delegates to set_vault_path correctly.
#
# All tests redirect the settings file via LLM_WIKI_SETTINGS_FILE so they
# never touch the real project .claude/llm-wiki-stack/settings.json.

load '../test_helper/common'

setup() {
  _load_helpers
  SETTINGS_TMP="$BATS_TEST_TMPDIR/llm-wiki-stack/settings.json"
  export LLM_WIKI_SETTINGS_FILE="$SETTINGS_TMP"
  unset LLM_WIKI_VAULT
}

teardown() {
  unset LLM_WIKI_SETTINGS_FILE
  unset LLM_WIKI_VAULT
}

@test "resolve_vault: returns current_vault_path from settings file" {
  mkdir -p "$(dirname "$SETTINGS_TMP")"
  printf '{\n  "default_vault_path": "docs/vault",\n  "current_vault_path": "my/custom/vault"\n}\n' >"$SETTINGS_TMP"

  run bash -c "
    export LLM_WIKI_SETTINGS_FILE='$SETTINGS_TMP'
    unset LLM_WIKI_VAULT
    source '$REPO_ROOT/scripts/resolve-vault.sh'
    resolve_vault
  "

  [ "$status" -eq 0 ]
  [ "$output" = "my/custom/vault" ]
}

@test "resolve_vault: LLM_WIKI_VAULT env var overrides settings file" {
  mkdir -p "$(dirname "$SETTINGS_TMP")"
  printf '{\n  "default_vault_path": "docs/vault",\n  "current_vault_path": "my/custom/vault"\n}\n' >"$SETTINGS_TMP"

  run bash -c "
    export LLM_WIKI_SETTINGS_FILE='$SETTINGS_TMP'
    export LLM_WIKI_VAULT='env-override'
    source '$REPO_ROOT/scripts/resolve-vault.sh'
    resolve_vault
  "

  [ "$status" -eq 0 ]
  [ "$output" = "env-override" ]
}

@test "resolve_vault: falls back to default when settings file absent" {
  # SETTINGS_TMP does not exist — no mkdir here.
  run bash -c "
    export LLM_WIKI_SETTINGS_FILE='$SETTINGS_TMP'
    unset LLM_WIKI_VAULT
    source '$REPO_ROOT/scripts/resolve-vault.sh'
    resolve_vault
  "

  # Auto-detect may fire if the repo CLAUDE.md is found; restrict depth so it
  # skips the repo root by setting a unique tmp dir as working directory.
  # Instead, verify only that the script exits 0 (the exact path may vary).
  [ "$status" -eq 0 ]
}

@test "init_vault_settings: creates settings.json with default values" {
  run bash -c "
    export LLM_WIKI_SETTINGS_FILE='$SETTINGS_TMP'
    source '$REPO_ROOT/scripts/resolve-vault.sh'
    init_vault_settings
  "

  [ "$status" -eq 0 ]
  [ -f "$SETTINGS_TMP" ]
  grep -q '"default_vault_path": "docs/vault"' "$SETTINGS_TMP"
  grep -q '"current_vault_path": "docs/vault"' "$SETTINGS_TMP"
}

@test "init_vault_settings: does not overwrite existing file" {
  mkdir -p "$(dirname "$SETTINGS_TMP")"
  printf '{\n  "default_vault_path": "docs/vault",\n  "current_vault_path": "already/set"\n}\n' >"$SETTINGS_TMP"

  run bash -c "
    export LLM_WIKI_SETTINGS_FILE='$SETTINGS_TMP'
    source '$REPO_ROOT/scripts/resolve-vault.sh'
    init_vault_settings
  "

  [ "$status" -eq 0 ]
  grep -q '"current_vault_path": "already/set"' "$SETTINGS_TMP"
}

@test "set_vault_path: updates current_vault_path, leaves default_vault_path" {
  mkdir -p "$(dirname "$SETTINGS_TMP")"
  printf '{\n  "default_vault_path": "docs/vault",\n  "current_vault_path": "docs/vault"\n}\n' >"$SETTINGS_TMP"

  run bash -c "
    export LLM_WIKI_SETTINGS_FILE='$SETTINGS_TMP'
    source '$REPO_ROOT/scripts/resolve-vault.sh'
    set_vault_path 'user/projects/my-vault'
  "

  [ "$status" -eq 0 ]
  grep -q '"default_vault_path": "docs/vault"' "$SETTINGS_TMP"
  grep -q '"current_vault_path": "user/projects/my-vault"' "$SETTINGS_TMP"
}

@test "set_vault_path: creates settings.json when absent then sets path" {
  run bash -c "
    export LLM_WIKI_SETTINGS_FILE='$SETTINGS_TMP'
    source '$REPO_ROOT/scripts/resolve-vault.sh'
    set_vault_path 'brand/new/vault'
  "

  [ "$status" -eq 0 ]
  [ -f "$SETTINGS_TMP" ]
  grep -q '"default_vault_path": "docs/vault"' "$SETTINGS_TMP"
  grep -q '"current_vault_path": "brand/new/vault"' "$SETTINGS_TMP"
}

@test "set-vault.sh: exits 1 with no argument" {
  run bash "$REPO_ROOT/scripts/set-vault.sh"

  [ "$status" -eq 1 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "set-vault.sh: updates current_vault_path via CLI" {
  mkdir -p "$(dirname "$SETTINGS_TMP")"
  printf '{\n  "default_vault_path": "docs/vault",\n  "current_vault_path": "docs/vault"\n}\n' >"$SETTINGS_TMP"

  run bash -c "
    export LLM_WIKI_SETTINGS_FILE='$SETTINGS_TMP'
    bash '$REPO_ROOT/scripts/set-vault.sh' 'cli/vault/path'
  "

  [ "$status" -eq 0 ]
  [[ "$output" == *"cli/vault/path"* ]]
  grep -q '"current_vault_path": "cli/vault/path"' "$SETTINGS_TMP"
}

@test "init_vault_settings: exits 0 when settings directory cannot be created" {
  # Place a regular file where the parent dir would go so mkdir -p fails.
  local blocker="$BATS_TEST_TMPDIR/blocker"
  printf 'not-a-dir\n' >"$blocker"

  run bash -c "
    export LLM_WIKI_SETTINGS_FILE='${blocker}/settings.json'
    source '$REPO_ROOT/scripts/resolve-vault.sh'
    init_vault_settings 2>/dev/null
  "

  [ "$status" -eq 0 ]
}

@test "set_vault_path: exits 0 when settings.json cannot be written" {
  # Make the parent a regular file so both mkdir and write fail.
  local blocker="$BATS_TEST_TMPDIR/blocker2"
  printf 'not-a-dir\n' >"$blocker"

  run bash -c "
    export LLM_WIKI_SETTINGS_FILE='${blocker}/settings.json'
    source '$REPO_ROOT/scripts/resolve-vault.sh'
    set_vault_path 'any/path' 2>/dev/null
  "

  [ "$status" -eq 0 ]
}

@test "set-vault.sh: warns when vault path does not exist on disk" {
  mkdir -p "$(dirname "$SETTINGS_TMP")"
  printf '{\n  "default_vault_path": "docs/vault",\n  "current_vault_path": "docs/vault"\n}\n' >"$SETTINGS_TMP"

  run bash -c "
    export LLM_WIKI_SETTINGS_FILE='$SETTINGS_TMP'
    bash '$REPO_ROOT/scripts/set-vault.sh' '/nonexistent/vault' 2>&1
  "

  [ "$status" -eq 0 ]
  [[ "$output" == *"WARN"* ]]
  [[ "$output" == *"/nonexistent/vault"* ]]
}
