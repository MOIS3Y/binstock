#!/usr/bin/env bats

source "$BATS_TEST_DIRNAME/test_helper.bash"

setup() {
    enable_mocks
    setup_tmpdir
}

teardown() {
    teardown_tmpdir
}

@test "send_notification: should send a notification when notify-send is available" {
    local message="Test notification message"
    # The mock will print to stderr, so we redirect it to stdout for the test
    run send_notification "" "$message" 2>&1
    
    [ "$status" -eq 0 ]
    [[ "$output" == *"MOCK_NOTIFY_ARGS: -t 2000 -a swapshot -i camera-photo Swapshot \
Test notification message"* ]]
}

@test "send_notification: should send a notification with a file thumbnail" {
    local screenshot_file="$TMPDIR/test.png"
    # Create a dummy file to simulate a screenshot
    touch "$screenshot_file"
    local message="File notification message"
    
    # Run the function with a file path. Redirect stderr to stdout.
    run send_notification "$screenshot_file" "$message" 2>&1
    
    [ "$status" -eq 0 ]
    # Check that the mock was called with the correct file path as an icon
    [[ "$output" == *"MOCK_NOTIFY_ARGS: -t 2000 -a swapshot -i $screenshot_file \
Swapshot File notification message: $(basename "$screenshot_file")"* ]]
}

@test "send_notification: should return 0 (success) if notify-send is not available" {
    # Save the original PATH
    local original_path="$PATH"
    # Clear the PATH to simulate a missing dependency
    export PATH=""
    
    run send_notification "" "No notify-send test"
    
    # Check that the function exited successfully
    [ "$status" -eq 0 ]
    # And that nothing was printed to stdout
    [ -z "$output" ]
    
    # Restore the PATH for other tests
    export PATH="$original_path"
}