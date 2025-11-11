# GitHub Actions CI Configuration

This directory contains the Continuous Integration (CI) configuration for the ComicInfo Swift package.

## Workflows

### `ci.yml` - Main CI Pipeline

Runs comprehensive tests across multiple platforms and validates code quality.

#### Jobs

1. **test-macos** - Run tests on macOS
   - Platform: `macos-26` runner
   - Uses Swift Package Manager directly

2. **test-ios** - Run tests on iOS Simulator
   - Platform: `macos-26` runner
   - Matrix strategy: iPhone 26 and iPad Pro 11-inch (M4)
   - iOS version: 26.0
   - Uses Xcode project generation for simulator testing

3. **lint** - Code formatting validation
   - Checks code formatting with `swift format`
   - Ensures consistent code style across the project

4. **package-validation** - Package integrity checks
   - Validates Swift package structure
   - Tests dependency resolution
   - Verifies debug and release builds
   - Tests package integration as a dependency

#### Triggers

- Push to `main` branches
- Pull requests to `main` branches
- Manual workflow dispatch

#### Requirements

- **Xcode**: Latest (includes Swift 6.2+)
- **Platforms**: macOS 26, iOS 26, watchOS 26, tvOS 26
- **Dependencies**: Foundation, XMLParser

## Platform Compatibility

The CI configuration is designed to work with GitHub Actions' available runners and simulators:

- **macOS**: Tests run directly on macOS 26 runners
- **iOS**: Tests run on iOS 26.0 simulators (iPhone and iPad)
- **watchOS**: Tests run on watchOS 26.0 simulators
- **tvOS**: Tests run on tvOS 26.0 simulators

## Debugging CI Issues

### Common Issues

1. **Simulator not found**: Check available simulators in CI logs
2. **Xcode version mismatch**: Ensure Xcode version supports target iOS/macOS versions
3. **Swift version incompatibility**: Verify swift-tools-version in Package.swift

### Local Testing

Test CI commands locally before pushing:

```bash
# Test macOS build
swift test
```

## Future Enhancements

Potential improvements for the CI pipeline:

- Add security scanning
- Add multi-Swift-version testing matrix
