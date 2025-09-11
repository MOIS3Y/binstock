#!/usr/bin/env bats

source "$BATS_TEST_DIRNAME/test_helper.bash"

setup() {
    enable_mocks
    setup_tmpdir
}

teardown() {
    teardown_tmpdir
}

# --- Tests for basic commands ---

@test "script should run 'save' command successfully" {
    # The default command 'save' is tested without any options.
    run "$SS_BIN_FILE" save
    # We expect a successful exit code.
    [ "$status" -eq 0 ]
    # The script should confirm that a screenshot was saved.
    [[ "$output" == *"Screenshot saved:"* ]]
}

@test "script should run 'copy' command successfully" {
    # The 'copy' command is tested.
    # We redirect stderr to stdout (2>&1) to capture mock output from `wl-copy`.
    run "$SS_BIN_FILE" copy 2>&1
    # We expect a successful exit code.
    [ "$status" -eq 0 ]
    # The script should confirm the screenshot was copied to the clipboard.
    [[ "$output" == *"Screenshot copied to clipboard"* ]]
}

@test "script should run 'savecopy' command successfully" {
    # The 'savecopy' command is tested.
    # We redirect stderr to stdout to capture mock output from both `cp` and `wl-copy`.
    run "$SS_BIN_FILE" savecopy 2>&1
    # We expect a successful exit code.
    [ "$status" -eq 0 ]
    # The script should confirm both saving and copying.
    [[ "$output" == *"(and copied to clipboard)"* ]]
}

# --- Tests for single options and their effects ---

@test "help option (-h) should show usage and exit" {
    # The -h option should print the usage information and exit without errors.
    run "$SS_BIN_FILE" -h
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
}

@test "version option (-v) should show version and exit" {
    # The -v option should print the version and exit.
    run "$SS_BIN_FILE" -v
    [ "$status" -eq 0 ]
    [[ "$output" == *"swapshot"* ]]
}

@test "capture option (-c) should trigger region capture" {
    # The -c option should switch the capture mode to 'region'.
    # We redirect stderr to capture mock output from `slurp`.
    run "$SS_BIN_FILE" -c 2>&1
    [ "$status" -eq 0 ]
    # The mock for `slurp` should be called.
    [[ "$output" == *"MOCK_SLURP_ARGS"* ]]
    # The default command 'save' should still be executed.
    [[ "$output" == *"Screenshot saved:"* ]]
}

@test "delay option (-d) should add a delay before capture" {
    # The -d option with a 1-second delay is tested. The output should confirm the countdown.
    run "$SS_BIN_FILE" -d 1
    [ "$status" -eq 0 ]
    [[ "$output" == *"Capturing in 1 seconds..."* ]]
    [[ "$output" == *"Capturing now..."* ]]
    [[ "$output" == *"Screenshot saved:"* ]]
}

@test "output-dir option (-o) should save to the specified directory" {
    # The -o option is used to specify a custom directory for saving screenshots.
    local custom_dir="$TMPDIR/custom"
    run "$SS_BIN_FILE" -o "$custom_dir"
    [ "$status" -eq 0 ]
    # The specified directory must be created.
    [ -d "$custom_dir" ]
    # The script must confirm the save operation.
    [[ "$output" == *"Screenshot saved:"* ]]
}

@test "notify option (-n) should send a notification" {
    # The -n option should trigger a desktop notification.
    # We redirect stderr to capture mock output from `notify-send`.
    run "$SS_BIN_FILE" -n 2>&1
    [ "$status" -eq 0 ]
    # The mock for `notify-send` should have been called.
    [[ "$output" == *"MOCK_NOTIFY_ARGS"* ]]
    [[ "$output" == *"Screenshot saved"* ]]
}

@test "edit option (-e) should open swappy" {
    # The -e option should trigger swappy.
    # We redirect stderr to capture mock output.
    run "$SS_BIN_FILE" -e 2>&1
    [ "$status" -eq 0 ]
    # The script should confirm the editing operation.
    [[ "$output" == *"Screenshot edited with swappy"* ]]
    # The mock for `swappy` should have been called.
    [[ "$output" == *"MOCK_SWAPPY_ARGS"* ]]
}

# --- Tests for combined arguments and options (complex scenarios) ---

@test "should handle 'save' with all options" {
    # Test a full combination of save command with all relevant options.
    local custom_dir="$TMPDIR/full_save"
    run "$SS_BIN_FILE" save -c -d 1 -o "$custom_dir" -n 2>&1
    
    [ "$status" -eq 0 ]
    # Check that a file was saved to the custom directory.
    [ -d "$custom_dir" ]
    [[ "$output" == *"Screenshot saved:"* ]]
    # Check that all mocks for the options were called.
    [[ "$output" == *"MOCK_SLURP_ARGS"* ]] # from -c
    [[ "$output" == *"Capturing in 1 seconds"* ]] # from -d
    [[ "$output" == *"MOCK_NOTIFY_ARGS"* ]] # from -n
}

@test "should handle 'copy' with all options" {
    # Test the copy command with region capture and notifications.
    run "$SS_BIN_FILE" copy -c -d 1 -n 2>&1

    [ "$status" -eq 0 ]
    [[ "$output" == *"Screenshot copied to clipboard"* ]]
    # Check that all mocks were called.
    [[ "$output" == *"MOCK_SLURP_ARGS"* ]]
    [[ "$output" == *"Capturing in 1 seconds"* ]]
    [[ "$output" == *"MOCK_NOTIFY_ARGS"* ]]
}

@test "should handle 'savecopy' with all options" {
    # Test the most complex combination: save, copy, region, delay, output, and notify.
    local custom_dir="$TMPDIR/full_savecopy"
    run "$SS_BIN_FILE" savecopy -c -d 1 -o "$custom_dir" -n 2>&1

    [ "$status" -eq 0 ]
    # Check for both save and copy messages.
    [[ "$output" == *"Screenshot saved:"* ]]
    [[ "$output" == *"(and copied to clipboard)"* ]]
    # Check that the custom directory was created.
    [ -d "$custom_dir" ]
    # Check all mock outputs.
    [[ "$output" == *"MOCK_SLURP_ARGS"* ]]
    [[ "$output" == *"Capturing in 1 seconds"* ]]
    [[ "$output" == *"MOCK_NOTIFY_ARGS"* ]]
}

@test "should handle 'edit' mode with capture and notify options" {
    # Test the edit mode, which is mutually exclusive with saving to a directory.
    run "$SS_BIN_FILE" -c -e -n 2>&1

    [ "$status" -eq 0 ]
    [[ "$output" == *"Screenshot edited with swappy"* ]]
    # Check that all relevant mocks were called.
    [[ "$output" == *"MOCK_SLURP_ARGS"* ]]
    [[ "$output" == *"MOCK_SWAPPY_ARGS"* ]]
    [[ "$output" == *"MOCK_NOTIFY_ARGS"* ]]
}

# --- Tests for invalid and mutually exclusive arguments ---

@test "script should fail with unknown command" {
    # An unknown command should cause the script to fail with an error message.
    run "$SS_BIN_FILE" unknown-command 2>&1
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: Unknown command"* ]]
}

@test "script should fail with unknown option" {
    # An unknown option should cause the script to fail.
    run "$SS_BIN_FILE" -x 2>&1
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: Unknown option: -x"* ]]
}

@test "script should fail with mutually exclusive options (-e and -o)" {
    # The `-e` and `-o` options are mutually exclusive and should cause a failure.
    run "$SS_BIN_FILE" -e -o "$TMPDIR" 2>&1
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: Options --edit and --output-dir are mutually exclusive"* ]]
}
