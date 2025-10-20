# Scripts Directory

This directory contains development scripts following the
[Scripts To Rule Them All](https://github.com/github/scripts-to-rule-them-all)
pattern.

## Available Scripts

### `script/build`
Build the app from the command line.

**Usage:**
```sh
script/build [macos|ios|all] [Debug|Release]
```

**Examples:**
```sh
script/build                    # Build macOS Debug (default)
script/build macos Release      # Build macOS Release
script/build ios                # Build iOS Debug
script/build all Release        # Build all platforms Release
```

### `script/run`
Build and run the app from the command line.

**Usage:**
```sh
script/run [macos|ios] [Debug|Release]
```

**Examples:**
```sh
script/run                      # Build and run macOS Debug (default)
script/run macos Release        # Build and run macOS Release
script/run ios                  # Build and run iOS Debug in Simulator
```

**Behavior:**
- **macOS**: Opens the built .app bundle
- **iOS**: Launches in iOS Simulator

### `script/test`
Run the test suite.

**Usage:**
```sh
script/test
```

### `script/format`
Format Swift code using swift-format.

**Usage:**
```sh
script/format
```

### `script/lint`
Run linting checks on the codebase.

**Usage:**
```sh
script/lint
```

### `script/cibuild`
Build script optimized for continuous integration environments.

**Usage:**
```sh
script/cibuild
```

## Quick Start

1. **Development workflow:**
   ```sh
   script/format    # Format code
   script/test      # Run tests
   script/run       # Build and run the app
   ```

2. **Release workflow:**
   ```sh
   script/format
   script/test
   script/build macos Release
   ```

3. **CI workflow:**
   ```sh
   script/cibuild
   ```

## Requirements

- **Xcode**: Latest stable version (check `.xcode-version`)
- **macOS**: Compatible with current Xcode requirements
- **Swift**: Latest stable version supported by Xcode

## Notes

- All scripts should be run from the project root directory
- Scripts use `set -e` to exit on any error
- Build artifacts are placed in Xcode’s standard DerivedData location
- The `script/run` command will automatically build the app before running it
