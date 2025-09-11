#!/usr/bin/env bash

# Configuration
SS_VERSION="0.1.0"
SS_DEFAULT_DELAY=0
SS_REQUIRED_DEPS=("grim" "slurp")
SS_FILENAME_FORMAT="${SS_FILENAME_FORMAT:-screenshot_%Y%m%d_%H%M%S.png}"

#######################################
# Print usage information
# Globals:
#   SS_DEFAULT_DELAY
#   SS_VERSION
# Arguments:
#   None
# Outputs:
#   Writes help text to stdout
# Example:
#   print_usage
#######################################
print_usage() {
    cat << EOF
Usage: ${0##*/} [COMMAND] [OPTIONS]

Capture and manage screen regions effortlessly.

Commands:
    save        Capture entire screen and save to file (default)
    copy        Capture entire screen and copy to clipboard  
    savecopy    Capture entire screen and both save to file and copy to clipboard

Options:
    -h, --help           Show this help message and exit
    -v, --version        Show version information
    -c, --capture        Select region to capture interactively
    -d, --delay SECONDS  Set delay before capture (default: $SS_DEFAULT_DELAY)
    -o, --output-dir DIR Specify output directory for saved files
    -e, --edit           Open swappy for editing after capture
    -n, --notify         Send desktop notification after capture

Examples:
    ${0##*/} save                 # Save full screenshot to default directory
    ${0##*/} copy -c              # Copy selected region to clipboard
    ${0##*/} savecopy -c -n       # Save and copy selected region with notification
    ${0##*/} -c -e                # Select region and edit with swappy
    ${0##*/} save -d 3 -o ~/Pics  # Save full screen with delay to custom directory
EOF
}

#######################################
# Print error message to stderr
# Arguments:
#   $1 - error message
# Outputs:
#   Writes error message to stderr
# Example:
#   print_error "File not found"
#######################################
print_error() {
    printf "Error: %s\n" "$1" >&2
}

#######################################
# Send desktop notification with screenshot thumbnail
# Arguments:
#   $1 - path to screenshot file (optional)
#   $2 - message for notification
# Returns:
#   0 - success or notify-send not available (silent fail)
# Outputs:
#   Sends desktop notification if notify-send is available
# Example:
#   send_notification "/path/to/screenshot.png" "Screenshot saved"
#######################################
send_notification() {
    local screenshot_path="$1"
    local message="${2:-Screenshot captured}"
    
    # Check if notify-send is available
    if ! command -v notify-send &> /dev/null; then
        return 0
    fi
    
    # Try to send notification with thumbnail if file exists
    if [[ -n "$screenshot_path" && -f "$screenshot_path" ]]; then
        local absolute_path
        absolute_path=$(realpath "$screenshot_path")
        notify-send -t 2000 -a "swapshot" -i "$absolute_path" \
            "Swapshot" "$message: $(basename "$absolute_path")"
    else
        # Use standard icon from theme when no screenshot available
        notify-send -t 2000 -a "swapshot" -i "camera-photo" \
            "Swapshot" "$message"
    fi
}

#######################################
# Check if a command exists in system PATH
# Arguments:
#   $1 - command name to check
# Returns:
#   0 - command exists
#   1 - command not found
# Outputs:
#   Error message to stderr if command not found
# Example:
#   check_dependency "grim"
#######################################
check_dependency() {
    local cmd=$1
    if ! command -v "$cmd" &> /dev/null; then
        print_error "'$cmd' is not installed. Please install it first."
        return 1
    fi
    return 0
}

#######################################
# Validate directory existence and write permissions
# Arguments:
#   $1 - directory path
#   $2 - directory type for error messages
#   $3 - create if missing (1 = create, 0 = do not create)
# Returns:
#   0 - directory exists and is writable
#   1 - directory validation failed
# Outputs:
#   Error messages to stderr if validation fails
# Example:
#   validate_directory "/tmp/screenshots" "output" 1
#######################################
validate_directory() {
    local dir=$1
    local dir_type=$2
    local create_if_missing=$3
    
    if [[ ! -d "$dir" ]]; then
        if [[ $create_if_missing -eq 1 ]]; then
            if ! mkdir -p "$dir" 2>/dev/null; then
                print_error "Cannot create ${dir_type} directory: $dir"
                return 1
            fi
            return 0
        else
            print_error "${dir_type} directory does not exist: $dir"
            return 1
        fi
    fi
    
    if [[ ! -w "$dir" ]]; then
        print_error "No write permission for ${dir_type} directory: $dir"
        return 1
    fi
    
    return 0
}

#######################################
# Get and validate output directory for screenshots
# Arguments:
#   $1 - user specified directory (from -o option) or empty
# Returns:
#   0 - success, outputs directory path to stdout
#   1 - error
# Outputs:
#   Valid directory path to stdout on success
# Example:
#   get_output_directory "~/Pictures"
#######################################
get_output_directory() {
    local user_dir=$1
    
    if [[ -n "$user_dir" ]]; then
        if validate_directory "$user_dir" "specified output" 1; then
            echo "$user_dir"
            return 0
        else
            return 1
        fi
    fi
    
    local default_dir="${XDG_SCREENSHOTS_DIR:-${XDG_PICTURES_DIR:-${HOME}/Pictures}}"
    
    if validate_directory "$default_dir" "default screenshot" 0; then
        echo "$default_dir"
        return 0
    else
        return 1
    fi
}

#######################################
# Capture screen region or entire screen
# Arguments:
#   $1 - capture mode: "full" or "region"
# Outputs:
#   Captured image to stdout
# Example:
#   capture_screen "full"
#######################################
capture_screen() {
    local mode=$1
    
    if [[ "$mode" == "region" ]]; then
        grim -g "$(slurp -w 0)" -
    else
        grim -
    fi
}

#######################################
# Process captured image based on command and options
#
# Arguments:
#   $1 - command:       Action to perform ("save", "copy", "savecopy").
#   $2 - output_dir:    Target directory (for save operations).
#   $3 - notify_flag:   1 to send a notification.
#   $4 - edit_flag:     1 to open in 'swappy'.
#   $5 - capture_mode:  "full" or "region" capture.
#
# Returns:
#   0 - Success. The function successfully completed the requested operation.
#   1 - Error. The function failed to perform the capture or an operation.
#
# Outputs:
#   - To stdout: Informative messages about the status of the operation.
#   - To stderr: N/A. All errors are handled internally or through exit codes.
#
# Example:
#   # Example 1: Save a screenshot of a specific region and get a notification
#   process_capture "save" "~/Pictures" 1 0 "region"
#
#   # Expected output to stdout:
#   # "Screenshot saved: ~/Pictures/2025-09-07-101530.png"
#
#   # Example 2: Edit a full screenshot with 'swappy' and get a notification
#   process_capture "save" "" 1 1 "full"
#
#   # Expected output to stdout:
#   # "Screenshot edited with swappy"
#
#   # Example 3: Copy a full screenshot to the clipboard and get a notification
#   process_capture "copy" "" 1 0 "full"
#
#   # Expected output to stdout:
#   # "Screenshot copied to clipboard"
#######################################
process_capture() {
    local command=$1
    local output_dir=$2
    local notify_flag=$3
    local edit_flag=$4
    local capture_mode=$5
    
    local filename 
    filename=$(date +"$SS_FILENAME_FORMAT")
    local full_path="${output_dir}/${filename}"
    local temp_file
    temp_file=$(mktemp /tmp/swapshot.XXXXXX.png)
    
    # Capture to temp file
    capture_screen "$capture_mode" > "$temp_file"
    
    if [[ $edit_flag -eq 1 ]]; then
        # Edit mode - open in swappy
        swappy -f - < "$temp_file"
        echo "Screenshot edited with swappy"
        if [[ $notify_flag -eq 1 ]]; then
            send_notification "" "Screenshot edited"
        fi
    else
        # Handle different commands
        case "$command" in
            save)
                cp "$temp_file" "$full_path"
                echo "Screenshot saved: $full_path"
                if [[ $notify_flag -eq 1 ]]; then
                    send_notification "$full_path" "Screenshot saved"
                fi
                ;;
            copy)
                wl-copy < "$temp_file"
                echo "Screenshot copied to clipboard"
                if [[ $notify_flag -eq 1 ]]; then
                    send_notification "" "Screenshot copied to clipboard"
                fi
                ;;
            savecopy)
                cp "$temp_file" "$full_path"
                wl-copy < "$temp_file"
                echo "Screenshot saved: $full_path (and copied to clipboard)"
                if [[ $notify_flag -eq 1 ]]; then
                    send_notification "$full_path" "Screenshot saved and copied"
                fi
                ;;
        esac
    fi
    
    # Cleanup
    rm -f "$temp_file"
    return 0
}

#######################################
# Parse command line arguments
#
# Arguments:
#   $@ - All command-line arguments passed to the script.
#
# Returns:
#   0 - Success. The function successfully parsed all arguments.
#   1 - Error. An invalid argument or option was provided.
#
# Outputs:
#   - A single line of comma-separated values to stdout on success. This output
#     represents the parsed configuration that the rest of the script will use.
#     The values are in the following order:
#     "show_help,show_version,command,delay,output_dir,notify_flag,edit_flag,capture_mode"
#
#   - Error messages to stderr for invalid arguments or option combinations.
#
# Example:
#   parse_arguments "savecopy" "-c" "-d" "5" "-o" "/home/user/screenshots" "-n"
#
#   Resulting output to stdout:
#   "0,0,savecopy,5,/home/user/screenshots,1,0,region"
#
#   Breakdown of the output values:
#   - show_help:      0 (help was not requested)
#   - show_version:   0 (version was not requested)
#   - command:        savecopy (screenshot will be saved and copied to clipboard)
#   - delay:          5 (a 5-second delay before capture)
#   - output_dir:     /home/user/screenshots (the save directory)
#   - notify_flag:    1 (a system notification will be sent)
#   - edit_flag:      0 (the screenshot will not be edited)
#   - capture_mode:   region (only a selected region will be captured)
#######################################
parse_arguments() {
    local command="save"
    local delay=$SS_DEFAULT_DELAY
    local output_dir=""
    local notify_flag=0
    local edit_flag=0
    local capture_mode="full"
    local show_help=0
    local show_version=0

    # Parse command if provided
    if [[ $# -gt 0 ]] && [[ "$1" != -* ]]; then
        case "$1" in
            save|copy|savecopy)
                command="$1"
                shift
                ;;
            *)
                print_error "Unknown command: $1"
                return 1
                ;;
        esac
    fi

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help=1
                shift
                ;;
            -v|--version)
                show_version=1
                shift
                ;;
            -c|--capture)
                capture_mode="region"
                shift
                ;;
            -d|--delay)
                if [[ $# -lt 2 ]]; then
                    print_error "Option '-d' requires an argument"
                    return 1
                fi
                if ! [[ $2 =~ ^[0-9]+$ ]]; then
                    print_error "Delay must be a positive integer"
                    return 1
                fi
                delay=$2
                shift 2
                ;;
            -o|--output-dir)
                if [[ $# -lt 2 ]]; then
                    print_error "Option '-o' requires an argument"
                    return 1
                fi
                output_dir="$2"
                shift 2
                ;;
            -e|--edit)
                edit_flag=1
                shift
                ;;
            -n|--notify)
                notify_flag=1
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                return 1
                ;;
            *)
                print_error "Unexpected argument: $1"
                return 1
                ;;
        esac
    done

    # Validate incompatible options
    if [[ $edit_flag -eq 1 && -n "$output_dir" ]]; then
        print_error "Options --edit and --output-dir are mutually exclusive"
        return 1
    fi

    echo "$show_help,$show_version,$command,$delay,$output_dir,$notify_flag,$edit_flag,$capture_mode"
    return 0
}

#######################################
# The main entry point of the script.
# Orchestrates the entire process from argument parsing to execution.
#
# Arguments:
#   $@ - All command-line arguments passed to the script.
#
# Returns:
#   0 - Success. The script completed the requested action successfully.
#   1 - Error. The script terminated due to an invalid command,
#       option, or a missing dependency.
#
# Outputs:
#   - To stdout: User-facing messages such as help text, version information,
#     and successful operation statuses.
#   - To stderr: Error messages for invalid arguments or missing dependencies.
#
# Example:
#   # Standard script invocation.
#   main "$@"
#
#######################################
main() {
    # Parse command line arguments
    local parsed_args
    if ! parsed_args=$(parse_arguments "$@"); then
        print_usage
        exit 1
    fi

    # Extract values from parsed arguments
    IFS=',' read -r show_help show_version command delay output_dir notify_flag edit_flag capture_mode <<< "$parsed_args"

    # Check if help or version was requested
    if [[ $show_help -eq 1 ]]; then
        print_usage
        exit 0
    fi

    if [[ $show_version -eq 1 ]]; then
        echo "swapshot ${SS_VERSION}"
        exit 0
    fi

    # Validate basic dependencies
    for dep in "${SS_REQUIRED_DEPS[@]}"; do
        if ! check_dependency "$dep"; then
            exit 1
        fi
    done

    # Additional dependencies based on options
    if [[ $edit_flag -eq 1 ]] && ! check_dependency "swappy"; then
        exit 1
    fi
    if [[ "$command" == "copy" || "$command" == "savecopy" ]] && ! check_dependency "wl-copy"; then
        exit 1
    fi

    # Get output directory for save operations
    local final_output_dir=""
    if [[ "$command" == "save" || "$command" == "savecopy" ]] && [[ $edit_flag -eq 0 ]]; then
        if ! final_output_dir=$(get_output_directory "$output_dir"); then
            exit 1
        fi
    fi

    # Add delay if specified
    if [[ $delay -gt 0 ]]; then
        printf "Capturing in %d seconds..." "$delay"
        for ((i=delay; i>0; i--)); do
            printf "\rCapturing in %d seconds... " "$i"
            sleep 1
        done
        printf "\rCapturing now...                             \n"
    fi

    # Execute capture
    if [[ $edit_flag -eq 1 ]]; then
        # Edit mode - pipe directly to swappy
        capture_screen "$capture_mode" | swappy -f -
        echo "Screenshot edited with swappy"
        if [[ $notify_flag -eq 1 ]]; then
            send_notification "" "Screenshot edited"
        fi
    else
        process_capture "$command" "$final_output_dir" "$notify_flag" "$edit_flag" "$capture_mode"
    fi
}

# Entry point
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
