#!/usr/bin/env bats
# Tests for tests/run-tests.sh
#
# Behaviors under test:
#   - --help prints usage and exits 0.
#   - --list prints the commands that would run for each tier without executing them.
#   - default (no tier) lists both Tier 0 and Tier 1.
#   - Unknown tier exits 2 with a clear error.

load '../test_helper/common'

SCRIPT="$REPO_ROOT/tests/run-tests.sh"

@test "run-tests: --help prints usage and exits 0" {
  run bash "$SCRIPT" --help

  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
  [[ "$output" == *"tier0"* ]]
  [[ "$output" == *"tier1"* ]]
  [[ "$output" == *"tier2"* ]]
}

@test "run-tests: --list tier0 names Tier 0 checks" {
  run bash "$SCRIPT" --list tier0

  [ "$status" -eq 0 ]
  [[ "$output" == *"shellcheck"* ]]
  [[ "$output" == *"markdownlint"* ]]
  [[ "$output" == *"validate-docs"* ]]
}

@test "run-tests: --list tier1 names Bats run" {
  run bash "$SCRIPT" --list tier1

  [ "$status" -eq 0 ]
  [[ "$output" == *"bats"* ]]
  [[ "$output" == *"tests/scripts/"* ]]
}

@test "run-tests: --list tier2 names smoke scripts" {
  run bash "$SCRIPT" --list tier2

  [ "$status" -eq 0 ]
  [[ "$output" == *"fresh-install"* ]]
  [[ "$output" == *"skill-schema"* ]]
}

@test "run-tests: --list with no tier lists Tier 0 + Tier 1" {
  run bash "$SCRIPT" --list

  [ "$status" -eq 0 ]
  [[ "$output" == *"shellcheck"* ]]
  [[ "$output" == *"bats"* ]]
  # Default must NOT include Tier 2 smoke by default.
  [[ "$output" != *"fresh-install"* ]]
}

@test "run-tests: --list all lists all three tiers" {
  run bash "$SCRIPT" --list all

  [ "$status" -eq 0 ]
  [[ "$output" == *"shellcheck"* ]]
  [[ "$output" == *"bats"* ]]
  [[ "$output" == *"fresh-install"* ]]
}

@test "run-tests: unknown tier exits 2" {
  run bash "$SCRIPT" --list tier99

  [ "$status" -eq 2 ]
  [[ "$output" == *"unknown tier"* ]]
}
