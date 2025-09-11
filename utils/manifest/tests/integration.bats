#!/usr/bin/env bats

source "$BATS_TEST_DIRNAME/test_helper.bash"

# --- Tests for basic options ---

@test "help option (-h) should show usage and exit" {
    run "$BM_BIN_FILE" -h
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
}

@test "version option (-v) should show version and exit" {
    run "$BM_BIN_FILE" -v
    [ "$status" -eq 0 ]
    [[ "$output" == *"manifest version"* ]]
}

# --- Tests for default behavior ---

@test "default run should show repository information" {
    run "$BM_BIN_FILE"
    [ "$status" -eq 0 ]
    [[ "$output" == *"BINSTOCK UTILITIES"* ]]
}

@test "default run should contain swapshot utility info" {
    run "$BM_BIN_FILE"
    [ "$status" -eq 0 ]
    [[ "$output" == *"swapshot"* ]]
    [[ "$output" == *"Screen capture"* ]]
    [[ "$output" == *"Wayland"* ]]
}

@test "default run should contain nix run command" {
    run "$BM_BIN_FILE"
    [ "$status" -eq 0 ]
    [[ "$output" == *"nix run"* ]]
    [[ "$output" == *"#swapshot"* ]]
}

@test "default run should contain GitHub URL" {
    run "$BM_BIN_FILE"
    [ "$status" -eq 0 ]
    [[ "$output" == *"github.com"* ]]
}
