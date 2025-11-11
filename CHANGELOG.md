# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-11

### Added

#### Core Library
- **Complete ComicInfo.xml parsing**: Full support for ComicInfo v2.0 schema specification
- **Multi-format loading**: Load from file paths, URLs, or XML strings with smart detection
- **Async/await support**: Modern Swift concurrency with `async` loading methods
- **Swift 6.2+ compatibility**: Built with latest Swift features and strict concurrency

#### Data Types
- **ComicInfo.Issue struct**: Complete issue metadata with 35+ properties
- **ComicInfo.Page struct**: Page information with type, dimensions, and metadata
- **Comprehensive enums**: AgeRating, Manga, BlackAndWhite, PageType with validation
- **Multi-value fields**: Arrays for characters, teams, locations, genres with raw data access

#### Smart Features
- **Type coercion**: Automatic string-to-int/double conversion with validation
- **Multi-value parsing**: Comma-separated strings automatically parsed to arrays
- **Boolean helpers**: Convenience properties like `isManga`, `isRightToLeft`, `isBlackAndWhite`
- **Page filtering**: `coverPages` and `storyPages` computed properties
- **Publication dates**: Smart date construction from year/month/day fields

#### Export Capabilities
- **JSON serialization**: Full Codable support with pretty-printed output
- **XML generation**: Round-trip XML export maintaining schema compliance
- **Data formats**: Export to Data, String, or write directly to files

#### Error Handling
- **Detailed error types**: ComicInfoError enum with specific error cases
- **Validation errors**: Clear messages for enum validation and range checking
- **Localized descriptions**: User-friendly error messages with context

#### Developer Experience
- **Comprehensive test suite**: 94 tests covering all functionality
- **Swift format integration**: Consistent code formatting with 2-space indentation
- **Complete documentation**: Extensive README with usage examples
- **CI/CD pipeline**: GitHub Actions for multi-platform testing

### Technical Details

#### Architecture
- **Nested types pattern**: `ComicInfo.Issue` and `ComicInfo.Page` avoiding name collisions
- **Protocol conformance**: Codable, Equatable, Hashable support throughout
- **Memory efficient**: Lazy computed properties and optional fields
- **Thread safe**: No mutable shared state, safe for concurrent access

#### Platform Support
- macOS 26+ (Tahoe)
- iOS 26+

#### Performance
- **Fast XML parsing**: Foundation XMLDocument-based parsing
- **Minimal allocations**: Efficient string handling and array operations
- **Lazy evaluation**: Computed properties only calculated when accessed

### Files Added
- `Sources/ComicInfo/ComicInfo.swift` (1,338 lines) - Main library implementation
- `Sources/ComicInfo/Version.swift` - Version information
- `Tests/ComicInfoTests/` - Complete test suite (1,259 lines total)
- `Tests/ComicInfoTests/Fixtures/` - XML test fixtures
- `Package.swift` - Swift Package Manager configuration
- `README.md` - Comprehensive documentation
- `.swift-format` - Code formatting configuration
- `.github/workflows/` - CI/CD pipeline

### Dependencies
- Foundation (XMLDocument, JSONEncoder, FileManager)
- Swift Testing framework for tests
- No external dependencies

---

## [0.1.0] - 2025-10-05

### Added
- Initial project structure
- Basic package skeleton
- Development dependencies setup
