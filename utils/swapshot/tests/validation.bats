#!/usr/bin/env bats

source "$BATS_TEST_DIRNAME/test_helper.bash"

setup() {
    setup_tmpdir
}

teardown() {
    teardown_tmpdir
}

@test "validate_directory: should return 0 for existing writable directory" {
    run validate_directory "$TMPDIR" "test" 0
    [ "$status" -eq 0 ]
}

@test "validate_directory: should return 1 for non-existing directory when create=0" {
    local non_existent_dir="$TMPDIR/nonexistent/path/12345"
    run validate_directory "$non_existent_dir" "specified output" 0
    [ "$status" -eq 1 ]
    [[ "$output" == *"specified output directory does not exist"* ]]
}

@test "validate_directory: should create directory when create=1" {
    local new_dir="$TMPDIR/new_subdir"
    run validate_directory "$new_dir" "test" 1
    [ "$status" -eq 0 ]
    [ -d "$new_dir" ]
}

@test "validate_directory: should return 1 for non-writable directory" {
    local unwritable_dir="$TMPDIR/unwritable"
    mkdir -p "$unwritable_dir"
    chmod -w "$unwritable_dir"
    run validate_directory "$unwritable_dir" "test" 0
    [ "$status" -eq 1 ]
    [[ "$output" == *"No write permission for test directory"* ]]
}

@test "validate_directory: should return 1 for a file instead of a directory" {
    local file_path="$TMPDIR/test_file"
    touch "$file_path"
    run validate_directory "$file_path" "test" 0
    [ "$status" -eq 1 ]
    [[ "$output" == *"test directory does not exist: $file_path"* ]]
}