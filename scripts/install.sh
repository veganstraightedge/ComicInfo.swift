#!/usr/bin/env bash

set -euo pipefail

# ComicInfo Swift CLI Installation Script
# This script downloads and installs the comicinfo CLI tool

REPO_URL="https://github.com/your-org/ComicInfo-swift"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="comicinfo"
TEMP_DIR=$(mktemp -d)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
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

# Check if running on supported platform
check_platform() {
    if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux-gnu"* ]]; then
        print_error "Unsupported platform: $OSTYPE"
        print_error "This script supports macOS and Linux only"
        exit 1
    fi
}

# Check if Swift is installed
check_swift() {
    if ! command -v swift &> /dev/null; then
        print_error "Swift is not installed"
        print_error "Please install Swift from https://swift.org/install/"
        exit 1
    fi

    local swift_version=$(swift --version | head -n1)
    print_status "Found Swift: $swift_version"
}

# Check if Git is installed
check_git() {
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed"
        print_error "Please install Git first"
        exit 1
    fi
}

# Check write permissions for install directory
check_permissions() {
    if [[ ! -w "$INSTALL_DIR" ]]; then
        if [[ "$EUID" -ne 0 ]]; then
            print_warning "No write permission to $INSTALL_DIR"
            print_warning "Will attempt to use sudo for installation"
            SUDO_REQUIRED=true
        else
            print_error "Cannot write to $INSTALL_DIR even as root"
            exit 1
        fi
    else
        SUDO_REQUIRED=false
    fi
}

# Download and build the CLI tool
install_comicinfo() {
    print_status "Downloading ComicInfo Swift..."
    cd "$TEMP_DIR"

    git clone --depth 1 "$REPO_URL" comicinfo-swift
    cd comicinfo-swift

    print_status "Building CLI tool in release mode..."
    swift build --configuration release --product comicinfo

    print_status "Installing to $INSTALL_DIR..."
    local binary_path=".build/release/$BINARY_NAME"

    if [[ ! -f "$binary_path" ]]; then
        print_error "Build failed - binary not found at $binary_path"
        exit 1
    fi

    if [[ "$SUDO_REQUIRED" == true ]]; then
        sudo cp "$binary_path" "$INSTALL_DIR/"
        sudo chmod +x "$INSTALL_DIR/$BINARY_NAME"
    else
        cp "$binary_path" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR/$BINARY_NAME"
    fi
}

# Verify installation
verify_installation() {
    if command -v "$BINARY_NAME" &> /dev/null; then
        local version=$($BINARY_NAME version | head -n1)
        print_success "Installation successful!"
        print_success "Installed: $version"
        print_status "Try: $BINARY_NAME help"
    else
        print_error "Installation failed - $BINARY_NAME not found in PATH"
        print_error "You may need to restart your shell or add $INSTALL_DIR to your PATH"
        exit 1
    fi
}

# Clean up temporary files
cleanup() {
    print_status "Cleaning up..."
    rm -rf "$TEMP_DIR"
}

# Handle script interruption
trap cleanup EXIT

# Main installation process
main() {
    echo "ComicInfo Swift CLI Installer"
    echo "=============================="
    echo

    print_status "Checking system requirements..."
    check_platform
    check_swift
    check_git
    check_permissions

    echo
    print_status "Starting installation..."
    install_comicinfo

    echo
    print_status "Verifying installation..."
    verify_installation

    echo
    print_success "ComicInfo CLI tool installed successfully!"
    echo
    echo "Usage examples:"
    echo "  $BINARY_NAME read ComicInfo.xml"
    echo "  $BINARY_NAME validate ComicInfo.xml"
    echo "  $BINARY_NAME convert ComicInfo.xml comic.json json"
    echo "  $BINARY_NAME help"
    echo
}

# Show help
show_help() {
    cat << EOF
ComicInfo Swift CLI Installer

USAGE:
    $0 [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -d, --install-dir DIR   Install directory (default: /usr/local/bin)
    --user                  Install to ~/.local/bin instead of /usr/local/bin

EXAMPLES:
    # Standard installation
    $0

    # Install to user directory
    $0 --user

    # Install to custom directory
    $0 --install-dir /opt/bin

REQUIREMENTS:
    - Swift 6.2+ (https://swift.org/install/)
    - Git
    - macOS or Linux

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--install-dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        --user)
            INSTALL_DIR="$HOME/.local/bin"
            mkdir -p "$INSTALL_DIR"
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Run main installation
main
