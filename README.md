# Dotfiles

Personal dotfiles managed with GNU Stow for easy configuration management across multiple machines.

## Structure

This repository uses GNU Stow to manage symlinks. Each package is a subdirectory that contains the files that should be linked to your home directory.

```
dotfiles/
├── bash/          # Bash configuration
├── zsh/           # Zsh configuration (includes Powerlevel10k)
├── nvim/          # Neovim configuration
├── git/           # Git configuration
├── cargo/         # Cargo/Rust configuration
├── emacs/         # Emacs configuration
├── fish/          # Fish shell configuration
├── pip/           # PIP configuration
├── htop/          # Htop configuration
├── zellij/        # Zellij terminal multiplexer configuration
└── yay/           # Yay AUR helper configuration
```

## Installation

### Prerequisites

- GNU Stow
- Git

### Quick Setup

```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the setup script (or manually stow packages)
./setup.sh
```

### Manual Setup

```bash
cd ~/dotfiles

# Stow individual packages as needed
stow bash
stow zsh
stow nvim
stow git
stow cargo
stow emacs
stow fish
stow pip
stow htop
stow zellij
stow yay
```

### Adding a New Package

1. Create a new directory for the package:
   ```bash
   mkdir ~/dotfiles/<package-name>
   ```

2. Move or copy your configuration files into the package directory, maintaining the relative path structure:
   ```bash
   # Example for a program that stores config in ~/.config/myprogram/
   mkdir -p ~/dotfiles/myprogram/.config/myprogram/
   mv ~/.config/myprogram/* ~/dotfiles/myprogram/.config/myprogram/
   ```

3. Stow the new package:
   ```bash
   cd ~/dotfiles
   stow <package-name>
   ```

## Removing a Package

```bash
cd ~/dotfiles
stow -D <package-name>
```

## Updating on Another Machine

```bash
# Pull latest changes
cd ~/dotfiles
git pull

# Restow all packages (or individual ones)
./setup.sh
```

## Notes

- Stow creates symlinks in your home directory pointing to the files in this repository
- Any changes made to the configuration files in your home directory will affect the repository
- Be careful not to include sensitive data (passwords, API keys) in your dotfiles
- Use `.gitignore` to exclude sensitive or machine-specific files

## Customization

This repository is intended to be a starting point. You should:

1. Fork this repository
2. Customize the configurations to your needs
3. Add your own packages as necessary
4. Update the repository location in setup.sh

## License

MIT
