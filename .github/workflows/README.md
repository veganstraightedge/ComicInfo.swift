# GitHub Actions CI Configuration

This directory contains the Continuous Integration (CI) configuration for the ComicInfo.swift package.

## Workflows

### `ci.yml` - Main CI Pipeline

Runs the tests on macOS and checks formatting and package structure.

#### Jobs

1. **test-macos** - Build and run tests on macOS
   - Platform: `xcode-27` runner (macOS 27)
   - Uses Swift Package Manager directly (`swift build`, `swift test --parallel`)

2. **lint** - Code formatting validation
   - `swift format lint --strict --recursive Sources Tests` (any finding fails)

3. **package-validation** - Package integrity checks
   - Describes the package structure
   - Tests dependency resolution
   - Verifies debug and release builds
   - Checks that the core types and `load` are exported

There is no iOS job. The package declares iOS but does not build for it yet, so nothing in CI covers iOS.

#### Triggers

- Push to `main`
- Pull requests

#### Requirements

- **Xcode**: 27+ (includes Swift 6.4+)
- **Platforms**: macOS 27
- **Dependencies**: Foundation (`XMLDocument`), Yams, swift-argument-parser

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

- Add an iOS build, once the package builds for iOS
- Add security scanning
- Add multi-Swift-version testing matrix
