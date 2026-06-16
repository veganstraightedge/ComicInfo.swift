# ComicInfo.swift

A Swift package for reading and writing ComicInfo.xml files,
following ComicInfo schema specifications from the
[Anansi Project](https://github.com/anansi-project/comicinfo).

A [`comicinfo`](https://github.com/veganstraightedge/comicinfo) Ruby gem is also available.

![Swift](https://img.shields.io/badge/swift-6.2%2B-orange.svg)
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
- ⚡ **Swift 6 Ready**: Built with Swift 6.2+ and modern concurrency support

## Requirements

- Swift 6.2+
- Foundation
- XMLParser (included in Foundation)

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
  .package(url: "https://github.com/veganstraightedge/ComicInfo.swift.git", from: "1.0.0")
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

### ComicInfo

The main namespace containing all types and loading methods.

#### Static Methods

- `load(from: String)` - Smart load from file path or XML string
- `load(from: URL)` - Load from file URL
- `load(from: URL) async` - Async load from URL
- `load(fromXML: String)` - Load from XML string

### ComicInfo.Issue

Represents a comic book issue with all metadata.

#### Properties

**Basic Info:**

- `title: String?` - Issue title
- `series: String?` - Series name
- `number: String?` - Issue number
- `volume: Int?` - Volume number
- `count: Int?` - Total issues in series
- `year: Int?` - Publication year
- `month: Int?` - Publication month (1-12)
- `day: Int?` - Publication day (1-31)

**Creator Fields:**

- `writer: String?` - Writer(s)
- `penciller: String?` - Penciller(s)
- `inker: String?` - Inker(s)
- `colorist: String?` - Colorist(s)
- `letterer: String?` - Letterer(s)
- `coverArtist: String?` - Cover artist(s)
- `editor: String?` - Editor(s)
- `translator: String?` - Translator(s)

**Publication Info:**

- `publisher: String?` - Publisher name
- `imprint: String?` - Imprint name
- `format: String?` - Publication format
- `languageISO: String?` - Language code

**Content Fields:**

- `summary: String?` - Story summary
- `notes: String?` - Additional notes
- `review: String?` - Review text
- `communityRating: Double?` - Rating (0.0-5.0)
- `ageRating: AgeRating?` - Age rating enum
- `blackAndWhite: BlackAndWhite?` - B&W status
- `manga: Manga?` - Manga/reading direction

**Multi-value Fields (String):**

- `charactersRawData: String?` - Characters (comma-separated)
- `teamsRawData: String?` - Teams (comma-separated)
- `locationsRawData: String?` - Locations (comma-separated)
- `genreRawData: String?` - Genres (comma-separated)
- `webRawData: String?` - Web URLs (space-separated)

**Multi-value Fields (Arrays):**

- `characters: [String]` - Parsed character names
- `teams: [String]` - Parsed team names
- `locations: [String]` - Parsed location names
- `genres: [String]` - Parsed genres
- `webUrls: [URL]` - Parsed web URLs

**Story Arc Fields:**

- `storyArc: String?` - Story arc name
- `storyArcNumber: String?` - Position in arc
- `storyArcs: [String]` - Multiple story arcs
- `storyArcNumbers: [String]` - Arc positions

**Page Info:**

- `pages: [Page]` - Page array
- `pageCount: Int?` - Total page count

#### Computed Properties

- `isManga: Bool` - True if manga format
- `isRightToLeft: Bool` - True if right-to-left reading
- `isBlackAndWhite: Bool` - True if black and white
- `hasPages: Bool` - True if pages array is not empty
- `coverPages: [Page]` - Filter to cover pages only
- `storyPages: [Page]` - Filter to story pages only
- `publicationDate: Date?` - Computed publication date

#### Methods

- `toJSONString() throws -> String` - Export to JSON string
- `toJSONData() throws -> Data` - Export to JSON data
- `toXMLString() throws -> String` - Export to XML string

### ComicInfo.Page

Represents a single page in a comic.

#### Properties

- `image: Int` - Page number/index
- `type: PageType` - Page type enum
- `doublePage: Bool` - Double-page spread flag
- `imageSize: Int` - File size in bytes
- `key: String` - Key/identifier
- `bookmark: String` - Bookmark text
- `imageWidth: Int` - Image width (-1 if unknown)
- `imageHeight: Int` - Image height (-1 if unknown)

#### Computed Properties

- `isCover: Bool` - True if cover page type
- `isStory: Bool` - True if story page type
- `isDeleted: Bool` - True if deleted page type
- `isDoublePage: Bool` - Same as `doublePage`
- `isBookmarked: Bool` - True if bookmark is set
- `dimensions: (width: Int?, height: Int?)` - Optional dimensions
- `dimensionsAvailable: Bool` - True if both dimensions known
- `aspectRatio: Double?` - Width/height ratio if available

### Enums

#### AgeRating

- `.unknown`
- `.adultsOnly18Plus`
- `.earlyChildhood`
- `.everyone`
- `.everyone10Plus`
- `.g`
- `.kidsToAdults`
- `.m`
- `.ma15Plus`
- `.mature17Plus`
- `.pg`
- `.r18Plus`
- `.ratingPending`
- `.teen`
- `.x18Plus`

#### Manga

- `.unknown`
- `.no`
- `.yes`
- `.yesAndRightToLeft`

#### BlackAndWhite

- `.unknown`
- `.no`
- `.yes`

#### PageType

- `.frontCover`
- `.innerCover`
- `.roundup`
- `.story`
- `.advertisement`
- `.editorial`
- `.letters`
- `.preview`
- `.backCover`
- `.other`
- `.deleted`

### Error Types

All errors conform to `ComicInfoError` enum:

- `.fileError(String)` - File access errors
- `.parseError(String)` - XML parsing errors
- `.invalidEnum(field:value:validValues:)` - Invalid enum values
- `.rangeError(field:value:min:max:)` - Numeric range violations
- `.typeCoercionError(field:value:expectedType:)` - Type conversion errors
- `.schemaError(String)` - Schema validation errors

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
