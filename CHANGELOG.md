# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **`ComicInfo.NumericField`**: the numeric fields and their rules (Year 1000–9999, Month 1–12, Day 1–31, Community Rating 0–5, whole numbers for the counts) as public API. `validate(_:)` checks text, `int(from:)` / `double(from:)` return the number. Use it to check a value before building an `Issue`, for example text typed into a form.
- **`Issue.validate()`**: throws `ComicInfoError.rangeError` when Year, Month, Day or Community Rating holds a value that loading would reject.

### Changed

- **`toXMLString()` and `save(to:)` now refuse an `Issue` that could not be loaded back.** They call `validate()` first, so an issue built with, say, `year: 86` throws instead of writing a ComicInfo.xml that fails to load. JSON and YAML export are unchanged.
- Loading uses `NumericField` for Year, Month, Day and Community Rating. A blank `<Year>` or `<CommunityRating>` element, or a Year with surrounding whitespace, now loads (as nil / the number) instead of throwing, matching Month and Day.

## [1.3.0] - 2026-11-16

### Fixed
- **The package now builds for iOS.** It declared iOS but read and wrote XML with `XMLDocument` / `XMLElement`, which Foundation only has on macOS. CI now builds the library for iOS.

### Changed
- **XML is read and written with [AEXML](https://github.com/tadija/AEXML)** (new dependency) instead of Foundation's `XMLDocument`. The public API is unchanged and the same documents load to the same values. The text of `toXMLString()` / `save(to:)` differs in formatting only: attributes are written in alphabetical order, `"` and `'` in text are escaped as `&quot;` / `&apos;`, newlines and tabs in text are written as `&#10;` / `&#9;`, empty elements self-close (`<Page ... />`), and the XML declaration carries `standalone="no"`.
- **Raised the minimum Swift toolchain to 6.4** (was 6.3) **and the minimum platforms to macOS / iOS 27** (was 26); `swift-tools-version`, `platforms`, and the documented requirements bumped to match. Building needs Xcode 27+.
- `platforms` now declares only macOS and iOS; the other Apple platforms are no longer declared or documented.
- CI runs on GitHub's `xcode-27` runner (macOS 27, in preview); there is no `macos-27` label yet.
- Corrected the `doc/` guides and API reference: examples that did not compile (argument order, a mismatched variable name, tuple unpacking), and properties and methods that were missing (`types`, `includesType`, the alternate-series fields, `toYAMLString()`, `save(to:)`).

## [1.2.0] - 2026-06-16

### Changed
- **`communityRating` now serializes as a string in JSON and YAML** (e.g. `"4.25"`), not a bare number. It remains a `Double?` in memory (validated 0–5) and round-trips symmetrically. This removes the YAML `4.25e+0` scientific-notation artifact (a Yams `Double` rendering quirk) and keeps the JSON and YAML representations uniform. Implemented via explicit `Issue.init(from:)` / `encode(to:)`.
- **Raised the minimum Swift toolchain to 6.3** (was 6.2); `swift-tools-version` and the documented requirement bumped to match.
- **Lint warnings now gate builds**: `script/lint` and CI run `swift format lint --strict` (any finding fails). Cleared the outstanding doc-comment warnings to go green.
- Repo housekeeping (no library/CLI behavior change): removed `scripts/install.sh` (no `curl | sh` installs) and the stale `scripts/` directory; rewrote `script/*` (`build` / `test` / `lint` / `format` / `run`) as thin Swift Package Manager wrappers, replacing the old Longbox/`xcodebuild` leftovers; trimmed the Makefile to build-from-source install helpers (dev now goes through `script/*`); extracted the README `## Usage` examples and `## API Reference` into `doc/*.md` files, each linked from a table of contents.

## [1.1.0] - 2026-06-15

### Added
- **YAML export**: `Issue.toYAMLString()` for Ruby `to_yaml` parity, via the Yams library (first package dependency).
- **Multi-value page `Type`**: `Page.includesType(_:)`, matching Ruby's `include_type?`.
- **`Issue.save(to:)`**: write the ComicInfo XML to a file path or URL (creates intermediate directories), matching Ruby's `Issue#save`.
- **CLI v1.1 (rebuilt on swift-argument-parser)**: subcommands `read` / `validate` / `convert` (+ auto `--help` / `--version`). `convert` is unified (any → any across XML / JSON / YAML) and subsumes the old `write`. Output format is inferred from the output file's extension or set with `--format` / `--xml` / `--json` / `--yaml` / `--yml`; omit the output file to write to stdout. Inputs accept file paths, URLs (`http(s)://`, `file://`), and XML strings.

### Changed
- Internal: split the single-file `Sources/ComicInfo/ComicInfo.swift` into per-type files (`Errors`, `Enums`, `Page`, `Issue`, `Version`) mirroring the Ruby gem layout. No API or behavior change.
- **Page `Type` is now multi-value** (the XSD `ComicPageType` is an `xs:list`): `Page.types: [PageType]` replaces the single `Page.type`, which is now a convenience getter (first type). A space-separated `Type="FrontCover Story"` parses to and serializes from multiple types. The Codable (JSON/YAML) key changes `type` → `types` (an array).

### Security
- **XXE hardening**: XML parsing no longer resolves external entities (`.nodeLoadExternalEntitiesNever`), preventing local-file disclosure and SSRF via a crafted ComicInfo.xml.

---

## [1.0.2] - 2026-06-14

### Added
- **ComicInfoCLI**: restored the `comicinfo` command-line tool (commands: read, validate, convert, write, version, help), recovered from orphaned source. Exposed as the `comicinfo` executable target.

### Fixed
- CLI now builds against the nested `ComicInfo.Version.current` introduced in 1.0.1.

---

## [1.0.1] - 2025-11-11

### Changed
- **Version enum nesting**: Moved `Version` enum inside `ComicInfo` namespace to prevent naming conflicts with other packages
- **API change**: `Version.current` is now `ComicInfo.Version.current`

### Technical Details
- Follows same nested pattern as `ComicInfo.Issue` and other types
- Prevents potential namespace collisions with other Swift packages
- Maintains consistency across the library's type organization

---

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
