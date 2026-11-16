# GitHub Actions CI Configuration

This directory contains the Continuous Integration (CI) configuration for the ComicInfo.swift package.

## Workflows

### `ci.yml` - Main CI Pipeline

Runs the tests on macOS and checks formatting and package structure.

#### Jobs

1. **test-macos** - Build and run tests on macOS
   - Platform: `xcode-27` runner (macOS 27)
   - Uses Swift Package Manager directly (`swift build`, `swift test --parallel`)

2. **build-ios** - Build the library for iOS
   - `xcodebuild -scheme ComicInfo -destination "generic/platform=iOS" build`
   - Build only; the tests run on macOS

3. **lint** - Code formatting validation
   - `swift format lint --strict --recursive Sources Tests` (any finding fails)

4. **package-validation** - Package integrity checks
   - Describes the package structure
   - Tests dependency resolution
   - Verifies debug and release builds
   - Checks that the core types and `load` are exported

#### Triggers

- Push to `main`
- Pull requests

#### Requirements

- **Xcode**: 27+ (includes Swift 6.4+)
- **Platforms**: macOS 27, iOS 27
- **Dependencies**: Foundation, AEXML, Yams, swift-argument-parser

## Debugging CI Issues

### Common Issues

1. **Xcode version mismatch**: Ensure the runner's Xcode supports the target macOS version
2. **Swift version incompatibility**: Verify `swift-tools-version` in `Package.swift`

### Local Testing

Run the same checks locally before pushing:

```sh
script/test
script/lint
```

## Future Enhancements

Potential improvements for the CI pipeline:

- Run the tests on an iOS simulator
- Add security scanning
- Add multi-Swift-version testing matrix
