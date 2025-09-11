# Binstock

**Handy utilities for modern desktop environments and workflow automation.**

> 🚧 **Work in Progress** - This repository is actively being developed. Utilities and APIs may change.

## 🎯 About

Binstock is a collection of focused, single-purpose utilities designed to enhance
productivity and automation in modern desktop environments. The tools are 
specifically crafted for Linux-based systems with emphasis on Wayland compositors 
and modern workflows.

### 🏗️ Why This Repository Exists

This repository was created to centralize and organize scripts as standalone 
utilities for seamless integration into Linux configurations. Historically, 
these utilities existed as scattered scripts within personal NixOS configurations,
which led to several challenges:

- **Configuration clutter** - Scripts mixed with system configuration files
- **Maintenance complexity** - Difficult to update and maintain across environments  
- **Lack of portability** - Hard to share and reuse individual utilities

### 🎨 Primary Use Cases

These utilities are designed to power backend logic for:
- **Interactive widgets** - Buttons, toggles, sliders in status bars (Waybar)
- **Notification systems** - Custom actions and handlers (SwayNC)
- **Desktop automation** - Workflow triggers and background processes

### 🎯 Design Philosophy

Each utility follows core design principles:

- **Flexibility** - Work as standalone CLI tools or integrated components
- **Universal output** - Consistent formats for easy parsing by various consumers
- **Portability** - Minimal dependencies beyond core Linux utilities
- **Test coverage** - Integration and unit tests ensure stability

### 🧩 Why Bash?

The choice of Bash for initial implementation is strategic:

- **Rapid prototyping** - Quickly validate ideas and user workflows
- **Portability** - Works across distributions, not just NixOS
- **Accessibility** - Easy to understand and modify for non-NixOS users
- **Dependency light** - Many utilities wrap existing Linux tools rather than adding new dependencies
- **Future-proof** - Each utility can be rewritten in a high-level language when needed, without breaking user experience

Some utilities naturally fit Bash as they primarily orchestrate existing system tools rather than implementing complex logic.

### ⚠️ Project Reality

This is a **non-commercial, open-source project** maintained in spare time. Please 
understand that:

- **Development pace** may vary based on available time and priorities
- **Feature requests** and bug fixes may take significant time to implement
- **Bash limitations** present trade-offs between portability and advanced features

### 🧪 Quality Commitment

Despite the challenges, we maintain high standards through:
- **Comprehensive testing** - Both integration and unit tests
- **API stability** - Careful consideration of CLI interface changes
- **Documentation** - Complete man pages and usage examples

### 🤝 Community Value

This repository aims to solve common problems for the Linux desktop community:
- **Avoid duplication** - No need to reinvent common utilities
- **Easy discovery** - Centralized collection of quality tools
- **Collaboration friendly** - Clean structure for contributions
- **Learning resource** - Examples of well-structured bash utilities

We believe that by working together, we can create a valuable resource that 
benefits the entire Linux desktop ecosystem.

## 📦 Available Utilities

### ✅ Currently Available

- **swapshot** - Advanced screenshot tool for Wayland with region selection, editing, and notifications
- **manifest** - Repository explorer and utility discovery tool

### 🔄 Planned Utilities  

- **apptoggle** - Application state toggler (launch if closed, close if running)
- *More utilities coming soon...*

## 🚀 Installation

### Quick Discovery
```bash
# See all available utilities without installation
nix run github:MOIS3Y/binstock/#manifest
```

### Individual Utilities
```bash
# Install specific utilities
nix profile install github:MOIS3Y/binstock/#swapshot
nix profile install github:MOIS3Y/binstock/#apptoggle
```

### Full Repository (Nix Flake)
Add to your system configuration:
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
    inputs.binstock.packages.${pkgs.system}.apptogle
    inputs.binstock.packages.${pkgs.system}.swapshot
    # More packages in the same way ...
  ];
}
```


## 🤝 Contributing

### Ideas and Suggestions
Have an idea for a useful utility? **We welcome suggestions!** Please:
1. Check existing [Issues](https://github.com/MOIS3Y/binstock/issues) for similar ideas
2. Open a new Issue describing your proposed utility
3. Discuss use cases and potential implementation

### Code Contributions
Want to implement a utility? **Fantastic!** Here's how to start:
1. Look for [Issues labeled "good first issue"](https://github.com/MOIS3Y/binstock/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)
2. Follow the existing code style and structure
3. Ensure your utility has:
   - Proper error handling
   - Shell completion (bash/zsh)
   - Man page documentation
   - Nix flake support

### Building Your Own Collection
Inspired to create your own utilities repository? **Go for it!** Feel free to:
- Fork this repository as a starting point
- Use the project structure as a template
- Adapt the build system for your needs
- Create your own focused set of tools

## ⭐ Support

If you find this repository useful for your workflow,
please consider giving it a ⭐ on GitHub!

Starring helps:
- Increase visibility to other users
- Guide development priorities
- Show appreciation for the work invested

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

*Building better desktop experiences, one utility at a time.*
