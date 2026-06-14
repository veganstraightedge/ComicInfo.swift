# ComicInfo Swift Makefile

.PHONY: all build install clean test format help release

# Configuration
BINARY_NAME = comicinfo
BUILD_DIR = .build
INSTALL_DIR = /usr/local/bin
RELEASE_DIR = $(BUILD_DIR)/release
DEBUG_DIR = $(BUILD_DIR)/debug

# Default target
all: build

# Build in debug mode
build:
	@echo "Building ComicInfo CLI (debug)..."
	swift build

# Build in release mode
release:
	@echo "Building ComicInfo CLI (release)..."
	swift build --configuration release

# Install CLI tool to system
install: release
	@echo "Installing $(BINARY_NAME) to $(INSTALL_DIR)..."
	@if [ ! -w $(INSTALL_DIR) ]; then \
		echo "Need sudo to install to $(INSTALL_DIR)"; \
		sudo cp $(RELEASE_DIR)/$(BINARY_NAME) $(INSTALL_DIR)/; \
		sudo chmod +x $(INSTALL_DIR)/$(BINARY_NAME); \
	else \
		cp $(RELEASE_DIR)/$(BINARY_NAME) $(INSTALL_DIR)/; \
		chmod +x $(INSTALL_DIR)/$(BINARY_NAME); \
	fi
	@echo "✅ Installation complete!"
	@echo "Try: $(BINARY_NAME) help"

# Install to user directory
install-user: release
	@echo "Installing $(BINARY_NAME) to ~/.local/bin..."
	@mkdir -p ~/.local/bin
	cp $(RELEASE_DIR)/$(BINARY_NAME) ~/.local/bin/
	chmod +x ~/.local/bin/$(BINARY_NAME)
	@echo "✅ User installation complete!"
	@echo "Make sure ~/.local/bin is in your PATH"
	@echo "Try: $(BINARY_NAME) help"

# Uninstall from system
uninstall:
	@echo "Removing $(BINARY_NAME) from $(INSTALL_DIR)..."
	@if [ ! -w $(INSTALL_DIR) ]; then \
		sudo rm -f $(INSTALL_DIR)/$(BINARY_NAME); \
	else \
		rm -f $(INSTALL_DIR)/$(BINARY_NAME); \
	fi
	@echo "✅ Uninstalled $(BINARY_NAME)"

# Uninstall from user directory
uninstall-user:
	@echo "Removing $(BINARY_NAME) from ~/.local/bin..."
	rm -f ~/.local/bin/$(BINARY_NAME)
	@echo "✅ Uninstalled $(BINARY_NAME) from user directory"

# Run tests
test:
	@echo "Running tests..."
	swift test

# Format code
format:
	@echo "Formatting code..."
	swift-format format --recursive Sources Tests --in-place

# Lint code
lint:
	@echo "Linting code..."
	swift-format lint --recursive Sources Tests

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	swift package clean
	rm -rf $(BUILD_DIR)

# Development: create symlink for testing
dev-link: build
	@echo "Creating development symlink..."
	@mkdir -p ~/.local/bin
	@ln -sf $(PWD)/$(DEBUG_DIR)/$(BINARY_NAME) ~/.local/bin/$(BINARY_NAME)-dev
	@echo "✅ Development link created: $(BINARY_NAME)-dev"

# Development workflow: build, test, and link
dev: clean build test integration-test dev-link
	@echo "✅ Development setup complete!"
	@echo "Use: $(BINARY_NAME)-dev <command>"

# Watch for changes and rebuild (requires entr)
watch:
	@echo "Watching for changes... (requires 'entr')"
	@find Sources -name "*.swift" | entr -r make build

# Test CLI functionality
test-cli: build
	@echo "Testing CLI functionality..."
	@./$(DEBUG_DIR)/$(BINARY_NAME) version
	@./$(DEBUG_DIR)/$(BINARY_NAME) help
	@echo "✅ CLI basic tests passed"

# Full integration test
integration-test: build
	@echo "Running integration tests..."
	@./$(DEBUG_DIR)/$(BINARY_NAME) read Tests/ComicInfoTests/Fixtures/valid_minimal/ComicInfo.xml > /dev/null
	@./$(DEBUG_DIR)/$(BINARY_NAME) validate Tests/ComicInfoTests/Fixtures/valid_minimal/ComicInfo.xml > /dev/null
	@./$(DEBUG_DIR)/$(BINARY_NAME) convert Tests/ComicInfoTests/Fixtures/valid_minimal/ComicInfo.xml /tmp/test.json json
	@./$(DEBUG_DIR)/$(BINARY_NAME) write /tmp/test.json /tmp/test_output.xml
	@./$(DEBUG_DIR)/$(BINARY_NAME) validate /tmp/test_output.xml > /dev/null
	@rm -f /tmp/test.json /tmp/test_output.xml
	@echo "✅ Integration tests passed"

# Package for distribution
package: release
	@echo "Creating distribution package..."
	@mkdir -p dist
	@cp $(RELEASE_DIR)/$(BINARY_NAME) dist/
	@tar -czf dist/$(BINARY_NAME)-macos.tar.gz -C dist $(BINARY_NAME)
	@echo "✅ Package created: dist/$(BINARY_NAME)-macos.tar.gz"

# Show help
help:
	@echo "ComicInfo Swift Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  build           Build in debug mode"
	@echo "  release         Build in release mode"
	@echo "  install         Install CLI tool to $(INSTALL_DIR) (requires sudo)"
	@echo "  install-user    Install CLI tool to ~/.local/bin"
	@echo "  uninstall       Remove CLI tool from system"
	@echo "  uninstall-user  Remove CLI tool from user directory"
	@echo "  test            Run Swift tests"
	@echo "  format          Format code with swift-format"
	@echo "  lint            Lint code with swift-format"
	@echo "  clean           Clean build artifacts"
	  dev-link        Create development symlink
	  dev             Full development setup (clean, build, test, link)
	  watch           Watch for changes and rebuild (requires entr)
	@echo "  test-cli        Test basic CLI functionality"
	@echo "  integration-test Run full integration tests"
	@echo "  package         Create distribution package"
	@echo "  help            Show this help"
	@echo ""
	@echo "Examples:"
	@echo "  make install         # Install system-wide"
	@echo "  make install-user    # Install for current user"
	@echo "  make test-cli        # Test CLI works"
