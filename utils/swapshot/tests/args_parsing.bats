#!/usr/bin/env bats

source "$BATS_TEST_DIRNAME/test_helper.bash"

setup() {
    setup_tmpdir
    enable_mocks
}

teardown() {
    teardown_tmpdir
}

# --- Tests for basic commands ---

@test "parse_arguments: default command is save" {
    run parse_arguments
    [ "$status" -eq 0 ]
    [[ "$output" == "0,0,save,0,,0,0,full" ]]
}

@test "parse_arguments: unknown command fails" {
    run parse_arguments foobar
    [ "$status" -eq 1 ]
    [[ "$output" == *"Unknown command"* ]]
}

@test "parse_arguments: copy command is parsed correctly" {
    run parse_arguments copy
    [ "$status" -eq 0 ]
    [[ "$output" == "0,0,copy,0,,0,0,full" ]]
}

@test "parse_arguments: savecopy command is parsed correctly" {
    run parse_arguments savecopy
    [ "$status" -eq 0 ]
    [[ "$output" == "0,0,savecopy,0,,0,0,full" ]]
}

# --- Tests for options and their combinations ---

@test "parse_arguments: short options are parsed correctly (without -e)" {
    run parse_arguments -c -d 5 -n -o "/tmp"
    [ "$status" -eq 0 ]
    [[ "$output" == "0,0,save,5,/tmp,1,0,region" ]]
}

@test "parse_arguments: short options are parsed correctly (with -e)" {
    run parse_arguments -c -d 5 -n -e
    [ "$status" -eq 0 ]
    [[ "$output" == "0,0,save,5,,1,1,region" ]]
}

@test "parse_arguments: long options are parsed correctly (without --edit)" {
    run parse_arguments --capture --delay 5 --notify --output-dir "/tmp"
    [ "$status" -eq 0 ]
    [[ "$output" == "0,0,save,5,/tmp,1,0,region" ]]
}

@test "parse_arguments: long options are parsed correctly (with --edit)" {
    run parse_arguments --capture --delay 5 --notify --edit
    [ "$status" -eq 0 ]
    [[ "$output" == "0,0,save,5,,1,1,region" ]]
}

@test "parse_arguments: options with a command are parsed correctly" {
    run parse_arguments copy -c -d 3
    [ "$status" -eq 0 ]
    [[ "$output" == "0,0,copy,3,,0,0,region" ]]
}

# --- Tests for incorrect arguments ---

@test "parse_arguments: delay without an argument fails" {
    run parse_arguments -d
    [ "$status" -eq 1 ]
    [[ "$output" == *"requires an argument"* ]]
}

@test "parse_arguments: output-dir without an argument fails" {
    run parse_arguments -o
    [ "$status" -eq 1 ]
    [[ "$output" == *"requires an argument"* ]]
}

@test "parse_arguments: invalid delay argument fails" {
    run parse_arguments -d abc
    [ "$status" -eq 1 ]
    [[ "$output" == *"must be a positive integer"* ]]
}

@test "parse_arguments: mutually exclusive options -e and -o fail" {
    run parse_arguments -e -o "/tmp"
    [ "$status" -eq 1 ]
    [[ "$output" == *"mutually exclusive"* ]]
}