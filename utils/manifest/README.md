# Manifest

A utility for displaying information about the binstock utilities repository.
Part of the [binstock](https://github.com/MOIS3Y/binstock) meta-repository
- a collection of convenient utilities for modern desktop environments and workflow automation.

## 🎯 About

Manifest provides a clean, formatted overview of all tools available in the binstock repository.
It serves as the entry point for discovering and learning about the available utilities.

## ✨ Features

- **Repository information**: Display owner, URL, and description
- **Utilities listing**: Clean formatted list of available tools
- **Easy discovery**: Quick access to installation commands and documentation links
- **Standard interface**: Familiar `-h/--help` and `-v/--version` options
- **Shell completion**: Full bash and zsh completion support
- **Professional documentation**: Comprehensive man page

## 📦 Installation

> **Note**: Installing this utility standalone may not be necessary for most users.
> It's primarily designed to provide a quick overview of available utilities and their documentation links.
> You might prefer to directly install the specific tools you need rather than the manifest itself.

### For Nix Users

#### Via Flake (Recommended)
```bash
# Run directly without installation
nix run github:MOIS3Y/binstock/#manifest

# Or install to profile (usually not needed)
nix profile install github:MOIS3Y/binstock/#manifest
```

#### As Part of System Configuration
Typically you'll want to install specific utilities rather than the manifest:

```nix
{ config, pkgs, inputs, ... }: {
  environment.systemPackages = [ 
    # Install actual utilities instead
    inputs.binstock.packages.${pkgs.system}.swapshot
    # inputs.binstock.packages.${pkgs.system}.other-tool
  ];
}
```

### Manual Installation

#### Using Meson Build System
```bash
# Usually you'll want to build specific utilities instead
cd binstock/utils/swapshot
meson setup build
meson compile -C build
meson install -C build
```

#### Simple Copy Method
```bash
# Consider copying specific utility scripts instead
sudo cp binstock/utils/swapshot/src/swapshot.sh /usr/local/bin/swapshot
sudo chmod +x /usr/local/bin/swapshot
```

## 🚀 Usage

### Basic Examples
```bash
# Quick overview of available utilities (no installation needed)
nix run github:MOIS3Y/binstock/#manifest

# Or if you have it installed

# Show repository information and available utilities
manifest

# Show version information
manifest --version

# Show help message
manifest --help
```

### Environment Variables
```bash
# Override default repository owner
REPO_OWNER="YOUR-GITHUB-NAME" manifest
```

### Primary Use Cases
1. **Discover available utilities** in the binstock repository
2. **Get quick access** to installation commands for each tool
3. **Find documentation links** for detailed usage instructions
4. **See repository information** without browsing GitHub

## 📚 Documentation

### Man Page
```bash
man manifest
```

### Shell Completion
- **Bash**: Auto-completion for options
- **Zsh**: Advanced menu-style completion

## 📝 License

MIT License - see LICENSE file for details.

## 🤝 Contributing

This utility is part of the binstock meta-repository.
Contributions are welcome! Please follow the code style and add tests for new features.

---

*Part of the [binstock](https://github.com/MOIS3Y/binstock) utilities collection*
*- making the Linux desktop experience more enjoyable.*
