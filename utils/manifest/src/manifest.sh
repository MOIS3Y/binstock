#!/usr/bin/env bash

# Configuration
MANIFEST_VERSION="0.1.0"
REPO_OWNER="${REPO_OWNER:-MOIS3Y}"
REPO_NAME="binstock"
REPO_URL="https://github.com/$REPO_OWNER/$REPO_NAME"

#######################################
# Print usage information
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes help text to stdout
# Example:
#   print_usage
#######################################
print_usage() {
    cat << EOF
Usage: ${0##*/} [OPTIONS]

Display information about binstock utilities repository.

Options:
    -h, --help      Show this help message and exit
    -v, --version   Show version information

Examples:
    ${0##*/}        # Show repository information
    ${0##*/} -v     # Show version information
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
# Print repository information and available utilities
# Globals:
#   REPO_OWNER
#   REPO_NAME  
#   REPO_URL
# Arguments:
#   None
# Outputs:
#   Writes formatted repository information to stdout
# Example:
#   print_repository_info
#######################################
print_repository_info() {
    cat << EOF
┌─────────────────────────────────────────────────────┐
│                  BINSTOCK UTILITIES                 │
├─────────────────────────────────────────────────────┤
│ Repository: $REPO_OWNER/$REPO_NAME
│ URL: $REPO_URL
│ Description: Collection of convenient utilities for 
│              modern desktop environments and 
│              workflow automation
└─────────────────────────────────────────────────────┘

Available Utilities:
────────────────────

1. swapshot - Screen capture and management tool for Wayland
    • Features: Region selection, editing, notifications, multiple output formats
    • Run: nix run github:$REPO_OWNER/$REPO_NAME/#swapshot
    • Docs: $REPO_URL/tree/master/utils/swapshot

To add a new utility, contribute to the repository!
EOF
}

#######################################
# Parse command line arguments
# Arguments:
#   $@ - all command line arguments
# Returns:
#   0 - success, 1 - error
# Outputs:
#   Comma-separated values: "show_help,show_version"
#   Error messages to stderr for invalid arguments
# Example:
#   parse_arguments "-v"
#######################################
parse_arguments() {
    local show_help=0
    local show_version=0

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

    echo "$show_help,$show_version"
    return 0
}

#######################################
# Main function - orchestrates the manifest display
# Globals:
#   MANIFEST_VERSION
# Arguments:
#   $@ - command line arguments
# Returns:
#   0 - success, 1 - error
# Outputs:
#   Repository information or version text
# Example:
#   main "$@"
#######################################
main() {
    # Parse command line arguments
    local parsed_args
    if ! parsed_args=$(parse_arguments "$@"); then
        print_usage
        exit 1
    fi

    IFS=',' read -r show_help show_version <<< "$parsed_args"

    # Check if help was requested
    if [[ $show_help -eq 1 ]]; then
        print_usage
        exit 0
    fi

    # Check if version was requested
    if [[ $show_version -eq 1 ]]; then
        echo "manifest version $MANIFEST_VERSION"
        exit 0
    fi

    # Default action: show repository information
    print_repository_info
    exit 0
}

# Entry point
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi