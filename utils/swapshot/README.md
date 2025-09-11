# Swapshot

A modern command-line utility for capturing and managing screen regions
on Wayland compositors. 
Part of the [binstock](https://github.com/MOIS3Y/binstock)
meta-repository - a collection of convenient utilities
for modern desktop environments and workflow automation.

## 🎯 About

Swapshot is **yet another screenshot utility** for Wayland,
not a replacement for `grimshot` or similar tools.
It focuses on improved user experience,
better integration with modern systems, and additional features like:

- Interactive region selection with `slurp`
- Desktop notifications with preview thumbnails  
- Flexible output options (file, clipboard, both)
- Integration with `swappy` for image editing
- Configurable delays and output directories
- Comprehensive shell completion (bash/zsh)
- Man page documentation

## ✨ Features

- **Multiple capture modes**: full screen, region selection
- **Multiple output options**: save to file, copy to clipboard, or both
- **Edit integration**: seamless editing with `swappy`
- **Notifications**: desktop notifications with screenshot previews
- **Configurable**: customizable filename format and output directories
- **Well documented**: complete man page and shell completion

## 📦 Installation

### For Nix Users

#### Via Flake (Recommended)
```bash
# Run directly
nix run github:MOIS3Y/binstock/#swapshot -- -v

# Or install to profile  
nix profile install github:MOIS3Y/binstock/#swapshot
```

#### As Part of System Configuration
Add to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    binstock.url = "github:MOIS3Y/binstock";
    binstock.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, binstock, ... }@inputs: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
```

Then in your `configuration.nix`:

```nix
{ config, pkgs, inputs, ... }: {
  environment.systemPackages = [ 
    inputs.binstock.packages.${pkgs.system}.swapshot
  ];
}
```

### Manual Installation

#### Using Meson Build System
```bash
git clone https://github.com/MOIS3Y/binstock.git
cd binstock/utils/swapshot

# Build and install
meson setup build
meson compile -C build
meson install -C build
```

#### Simple Copy Method
```bash
# Copy script to PATH
sudo cp src/swapshot.sh /usr/local/bin/swapshot
sudo chmod +x /usr/local/bin/swapshot

# Install man page
sudo cp man/man1/swapshot.1 /usr/local/share/man/man1/
sudo mandb

# Install completions (optional)
sudo cp completions/bash/swapshot /usr/share/bash-completion/completions/
sudo cp completions/zsh/_swapshot /usr/share/zsh/site-functions/
```

## 🚀 Usage

### Basic Examples
```bash
# Save full screen to default directory
swapshot save

# Copy selected region to clipboard  
swapshot copy --capture

# Save and copy with notification
swapshot savecopy --capture --notify

# Select region and edit with swappy
swapshot --capture --edit

# Save with 3-second delay to custom directory
swapshot save --delay 3 --output-dir ~/Pictures

# More use cases in help
swapshot --help
```

### Hyprland Key Binding Example
```hyprlang
# ~/.config/hypr/hyprland.conf
bind = SUPER, S, exec, swapshot save --notify
bind = SUPER SHIFT, S, exec, swapshot --capture --edit --notify
```

### Waybar Custom Widget Example
```json
// ~/.config/waybar/config
"custom/screenshot": {
    "format": "📷",
    "on-click": "swapshot save --notify",
    "on-click-right": "swapshot --capture --edit --notify",
    "tooltip": false
}
```

## 📚 Documentation

### Man Page
```bash
man swapshot
```

### Shell Completion
- **Bash**: Auto-completion for options and directories
- **Zsh**: Advanced menu-style completion with descriptions

### Environment Variables
- `XDG_SCREENSHOTS_DIR`: Primary screenshot directory
- `XDG_PICTURES_DIR`: Fallback directory  
- `SS_FILENAME_FORMAT`: Custom filename format (strftime)

## 📝 License

MIT License - see LICENSE file for details.

## 🤝 Contributing

This utility is part of the binstock meta-repository. Contributions are welcome!
Please follow the code style and add tests for new features.

---

*Part of the [binstock](https://github.com/MOIS3Y/binstock) utilities collection*
*- making the Linux desktop experience more enjoyable.*
