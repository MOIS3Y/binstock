#!/usr/bin/env bash

# Define the root directory of the project, relative to this script
# BATS_TEST_DIRNAME points to the directory of the currently running test file (tests/)
export BM_ROOT_DIR="$BATS_TEST_DIRNAME/.."

# Define the path to the main script
export BM_BIN_FILE="$BM_ROOT_DIR/src/manifest.sh"

# Sourced automatically by `bats`
source "$BM_BIN_FILE"

# --- Test Environment Setup Functions ---

setup_tmpdir() {
    # Create a unique temporary directory for each test case
    TMPDIR="$(mktemp -d "${BATS_TMPDIR}/manifest.XXXXXX")"
    export TMPDIR
}

teardown_tmpdir() {
    # Clean up the temporary directory after the test is complete
    [[ -n "$TMPDIR" && -d "$TMPDIR" ]] && rm -rf "$TMPDIR"
}
