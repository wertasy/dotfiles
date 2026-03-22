#!/bin/bash

set -e

DOTFILES_DIR="${HOME}/dotfiles"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

if [ ! -d "$DOTFILES_DIR" ]; then
    print_error "Dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

cd "$DOTFILES_DIR"

if ! command -v stow &> /dev/null; then
    print_error "GNU Stow is not installed"
    print_info "Install it with:"
    print_info "  Debian/Ubuntu: sudo apt install stow"
    print_info "  Arch: sudo pacman -S stow"
    print_info "  macOS: brew install stow"
    exit 1
fi

print_info "Setting up dotfiles with GNU Stow..."

for package in "$DOTFILES_DIR"/*/; do
    package_name=$(basename "$package")
    if [ -d "$package" ] && [ "$package_name" != ".git" ]; then
        print_info "Stowing $package_name..."
        stow -R "$package_name"
        print_success "Stowed $package_name"
    fi
done

print_success "Dotfiles setup complete!"

print_info "Enabling bing-wallpaper systemd service..."
systemctl --user daemon-reload
systemctl --user enable bing-wallpaper.timer
systemctl --user start bing-wallpaper.timer
print_success "bing-wallpaper timer enabled and started"
print_info "Run 'systemctl --user start bing-wallpaper.service' to download wallpaper immediately"

print_info "You can now manage your configurations in $DOTFILES_DIR"
print_info "To remove a package, run: stow -D <package-name>"
print_info "You may need to reload your shell for changes to take effect:"
print_info "  For bash: source ~/.bashrc"
print_info "  For zsh:  source ~/.zshrc"

print_warning "Firefox user.js requires manual setup:"
print_info "  ln -sf ~/dotfiles/firefox/.config/mozilla/firefox/user.js ~/.config/mozilla/firefox/<profile>/user.js"
print_info "  Replace <profile> with your Firefox profile directory name (e.g., xxxxxxxx.default-release)"
