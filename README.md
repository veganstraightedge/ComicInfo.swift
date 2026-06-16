# ComicInfo.swift

A Swift package for reading and writing ComicInfo.xml files,
following ComicInfo schema specifications from the
[Anansi Project](https://github.com/anansi-project/comicinfo).

A [`comicinfo`](https://github.com/veganstraightedge/comicinfo) Ruby gem is also available.

![Swift](https://img.shields.io/badge/swift-6.3%2B-orange.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20iOS-lightgrey.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

## Features

- 📚 **Complete Schema Support**: Full ComicInfo v2.0 schema implementation
- 🔧 **Idiomatic Swift API**: Swift-style interface with proper naming conventions
- 📁 **Flexible Loading**: Load from file paths, URLs, or XML strings
- 🌍 **Unicode Support**: Full Unicode and special character handling
- 📖 **Manga Support**: Right-to-left reading direction and manga-specific fields
- ✅ **Comprehensive Validation**: Schema-compliant enum validation and type coercion
- 🚨 **Detailed Error Handling**: Swift error types with helpful error messages
- 📊 **Export Support**: JSON and property list serialization support
- ⚡ **Swift 6 Ready**: Built with Swift 6.3+ and modern concurrency support

## Requirements

- Swift 6.3+
- Foundation
- XMLParser (included in Foundation)

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
  .package(url: "https://github.com/veganstraightedge/ComicInfo.swift.git", from: "1.2.0")
]
```

Or add it through Xcode:

1. File → Add Package Dependencies
2. Enter the repository URL
3. Choose your version requirements

## Usage

- [Loading ComicInfo.xml Files](doc/loading.md)
- [Accessing Issue Data](doc/accessing-issue-data.md)
- [Working with Pages](doc/working-with-pages.md)
- [Export Functionality (JSON & XML)](doc/export.md)
- [Error Handling](doc/error-handling.md)
- [Creating Issues Programmatically](doc/creating-issues.md)

## API Reference

- [`ComicInfo` (namespace + loading)](doc/api-comicinfo.md)
- [`ComicInfo.Issue`](doc/api-issue.md)
- [`ComicInfo.Page`](doc/api-page.md)
- [Enums](doc/api-enums.md)
- [Error Types](doc/api-errors.md)

---

## Platform Support

- **macOS** 26+ (Tahoe)
- **iOS** 26.0+

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Anansi Project](https://github.com/anansi-project/comicinfo) for ComicInfo schema specification
- [ComicRack](http://comicrack.cyolito.com/) for the original ComicInfo.xml format

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Follow TDD practices - write tests first
4. Ensure all tests pass (`script/test`)
5. Run `script/format` on your code
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## Development

### Running Tests

```sh
script/test
```

### Code Formatting

This project uses `swift format` for code formatting:

```sh
# Check formatting
script/lint

# Auto-format code
script/format
```

### Package Validation

Validate the package structure and dependencies:

```sh
# Describe package structure
swift package describe --type json

# Resolve dependencies
swift package resolve

# Show dependency tree
swift package show-dependencies

# Build in debug mode
script/build

# Build in release mode
script/build --configuration release
```

### Continuous Integration

The project uses GitHub Actions for CI with the following checks:

- **macOS Tests**: Run full test suite on macOS 26
- **Code Formatting**: Verify code follows formatting standards
- **Package Validation**: Ensure package can be resolved and built

CI runs on every push to `main` branches and on pull requests.
