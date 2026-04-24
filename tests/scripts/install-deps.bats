#!/usr/bin/env bats
# Tests for tests/install-deps.sh
#
# Behaviors under test:
#   - --help prints usage and exits 0.
#   - --dry-run prints intended install commands and exits 0 without installing.
#   - --check reports status without installing; exit 0 iff everything present.
#   - Unknown flags exit 2 with usage on stderr.
#   - Unsupported OS (non-Darwin, non-Linux) exits 1 with a clear error.

load '../test_helper/common'

SCRIPT="$REPO_ROOT/tests/install-deps.sh"

@test "install-deps: --help prints usage and exits 0" {
  run bash "$SCRIPT" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"--dry-run"* ]]
  [[ "$output" == *"--check"* ]]
}

@test "install-deps: --dry-run prints intended commands and exits 0" {
  run bash "$SCRIPT" --dry-run

  [ "$status" -eq 0 ]
  [[ "$output" == *"dry-run mode"* ]]
  # At least one of the tools should have a [dry-run] line (unless the system
  # already has every tool present — in that case the output contains no
  # [dry-run] lines, which is also valid).
  [[ "$output" == *"[install-deps] done."* || "$output" == *"[dry-run]"* ]]
}

@test "install-deps: --check reports status without side effects" {
  run bash "$SCRIPT" --check

  # Exit 0 if every tool present, 1 if anything missing. Both are valid.
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  # Each tool is reported as either OK: or MISSING:.
  [[ "$output" == *"OK: jq"* || "$output" == *"MISSING: jq"* ]]
}

@test "install-deps: unknown flag exits 2" {
  run bash "$SCRIPT" --nonsense

  [ "$status" -eq 2 ]
  [[ "$output" == *"unknown option"* ]]
}

@test "install-deps: unsupported OS exits 1" {
  # Prepend a fake uname that reports a bogus OS.
  local fake_bin="$BATS_TEST_TMPDIR/bin"
  mkdir -p "$fake_bin"
  cat >"$fake_bin/uname" <<'EOF'
#!/bin/sh
echo BogusOS
EOF
  chmod +x "$fake_bin/uname"

  run env PATH="$fake_bin:$PATH" bash "$SCRIPT" --check

  [ "$status" -eq 1 ]
  [[ "$output" == *"unsupported OS"* ]]
}
