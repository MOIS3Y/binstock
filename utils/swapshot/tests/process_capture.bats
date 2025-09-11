#!/usr/bin/env bats

source "$BATS_TEST_DIRNAME/test_helper.bash"

setup() {
    enable_mocks
    setup_tmpdir
    # Mock `capture_screen` to create a dummy file.
    capture_screen() {
        local temp_file=$(mktemp "$TMPDIR/mocked_capture.XXXXXX.png")
        echo "MOCK_CAPTURE_SCREEN" > "$temp_file"
        echo "$temp_file"
    }
}

teardown() {
    teardown_tmpdir
}

@test "process_capture: 'save' command saves screenshot to file" {
    local output_dir="$TMPDIR"
    run process_capture "save" "$output_dir" 0 0 "full"

    [ "$status" -eq 0 ]
    [[ "$output" == *"Screenshot saved:"* ]]
    # Verify a new file was created in the output directory
    [ -n "$(ls -A "$output_dir")" ]
}

@test "process_capture: 'copy' command copies screenshot to clipboard" {
    run process_capture "copy" "" 0 0 "full" 2>&1

    [ "$status" -eq 0 ]
    [[ "$output" == *"Screenshot copied to clipboard"* ]]
    # Verify that `wl-copy` mock was called
    [[ "$output" == *"MOCK_WL-COPY_ARGS"* ]]
}

@test "process_capture: 'savecopy' command both saves and copies" {
    local output_dir="$TMPDIR"
    run process_capture "savecopy" "$output_dir" 0 0 "full" 2>&1

    [ "$status" -eq 0 ]
    [[ "$output" == *"Screenshot saved: "* ]]
    [[ "$output" == *"(and copied to clipboard)"* ]]
    # Verify a new file was created
    [ -n "$(ls -A "$output_dir")" ]
    # Verify that `wl-copy` mock was called
    [[ "$output" == *"MOCK_WL-COPY_ARGS"* ]]
}