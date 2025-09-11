# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-09-10

### Added
- Initial release of Swapshot utility
- Core functionality: screen capture, region selection, file saving, clipboard copying
- Command system: `save`, `copy`, `savecopy` commands
- Options support: `--capture`, `--delay`, `--output-dir`, `--edit`, `--notify`
- Desktop notifications with screenshot previews
- Comprehensive shell completion for bash and zsh
- Professional man page documentation
- Nix flake support for easy installation
- Meson build system integration
- Dependency validation and error handling
- Configurable filename format via `SS_FILENAME_FORMAT` environment variable
- Support for XDG directory standards (`XDG_SCREENSHOTS_DIR`, `XDG_PICTURES_DIR`)

### Technical Details
- Written in pure bash for portability
- Modular function-based architecture
- Proper error handling and user feedback
- Integration with Wayland ecosystem tools (grim, slurp, swappy, wl-copy)
- Graceful degradation for optional dependencies

## [Unreleased]

### Planned Features
- Support for multiple monitors
- Custom capture regions via command line arguments
- Upload to cloud services integration
- Advanced editing options
- History management of screenshots
- Plugins system for extended functionality
- GUI configuration interface
- Video capture support

### Known Issues
- Limited Windows support (WSL only)
- Performance optimization for large screens
- Better handling of Wayland compositor differences
