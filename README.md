# ComicInfo Swift Package

A Swift package that provides an idiomatic interface for reading and writing ComicInfo.xml files,
following the official ComicInfo schema specifications from the
[Anansi Project](https://github.com/anansi-project/comicinfo).

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
  .package(url: "https://github.com/your-org/ComicInfo-swift.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Choose your version requirements

## Usage

### Loading ComicInfo Files

```swift
import ComicInfo

// Load from file path
let comic = try ComicInfo.load(from: "path/to/ComicInfo.xml")

// Load from XML string
let xmlContent = try String(contentsOfFile: "ComicInfo.xml")
let comic = try ComicInfo.load(fromXML: xmlContent)

// Async loading
let comic = try await ComicInfo.loadAsync(from: "path/to/ComicInfo.xml")
```

### Accessing Comic Information

```swift
// Basic information
print(comic.title)  // "The Amazing Spider-Man"
print(comic.series) // "The Amazing Spider-Man"
print(comic.number) // "1"
print(comic.count)  // 600
print(comic.volume) // 3

// Publication details
print(comic.publisher) // "Marvel Comics"
print(comic.year)      // 2018
print(comic.month)     // 3
print(comic.day)       // 15

// Creator information
print(comic.writer)      // "Dan Slott, Christos Gage"
print(comic.penciller)   // "Ryan Ottley"
print(comic.coverArtist) // "Ryan Ottley"

// Content details
print(comic.pageCount)   // 20
print(comic.genre)       // "Superhero, Action, Adventure"
print(comic.languageISO) // "en-US"
print(comic.format)      // "Digital"

// Ratings and reviews
print(comic.ageRating)       // .teen
print(comic.communityRating) // 4.25
```

### Convenience Properties

```swift
// Boolean helpers
print(comic.isManga)         // false
print(comic.isRightToLeft)   // false
print(comic.isBlackAndWhite) // false

// Page information
print(comic.hasPages)     // true
print(comic.pages.count)  // 12

// Get specific page types
let covers = comic.coverPages
let stories = comic.storyPages

// Multi-value fields as arrays
let characters = comic.charactersArray // ["Spider-Man", "Peter Parker", ...]
let teams = comic.teamsArray           // ["Avengers"]
let locations = comic.locationsArray   // ["New York City", "Manhattan", ...]
let genres = comic.genresArray         // ["Superhero", "Action", "Adventure"]
let webUrls = comic.webUrlsArray       // [URL(...), URL(...)]
```

### Working with Pages

```swift
for page in comic.pages {
  print("Page \(page.image): \(page.type)")

  if page.isDoublePage {
    print("  Double page spread")
  }

  if let bookmark = page.bookmark {
    print("  Bookmark: \(bookmark)")
  }

  if let width = page.imageWidth, let height = page.imageHeight {
    print("  Dimensions: \(width)x\(height)")
  }
}

// Page type checks
let page = comic.pages.first!
print(page.isCover)   // true for frontCover, backCover, innerCover
print(page.isStory)   // true for story pages
print(page.isDeleted) // true for deleted pages
```

### Manga Support

```swift
// Load a manga ComicInfo file
let manga = try ComicInfo.load(from: "path/to/manga/ComicInfo.xml")

print(manga.title)           // "進撃の巨人"
print(manga.series)          // "Attack on Titan"
print(manga.manga)           // .yesAndRightToLeft
print(manga.isRightToLeft)   // true
print(manga.languageISO)     // "ja-JP"
print(manga.isBlackAndWhite) // true
print(manga.blackAndWhite)   // .yes
```

### Error Handling

```swift
do {
  let comic = try ComicInfo.load(from: "nonexistent.xml")
} catch ComicInfoError.fileNotFound(let path) {
  print("File not found: \(path)")
} catch ComicInfoError.parseError(let message) {
  print("Parse error: \(message)")
} catch ComicInfoError.invalidEnum(let field, let value, let validValues) {
  print("Invalid enum: \(field) = '\(value)', valid: \(validValues)")
} catch ComicInfoError.valueOutOfRange(let field, let value, let range) {
  print("Out of range: \(field) = \(value), range: \(range)")
} catch ComicInfoError.typeCoercionError(let message) {
  print("Type coercion error: \(message)")
}
```

## Schema Support

This package fully supports the ComicInfo v2.0 XSD schema with all field types:

### String Fields
- Title, Series, Number, Summary, Notes
- Creator fields (Writer, Penciller, Inker, Colorist, Letterer, CoverArtist, Editor, Translator)
- Publication fields (Publisher, Imprint, Genre, Web, LanguageISO, Format)
- Character/Location fields (Characters, Teams, Locations, MainCharacterOrTeam)
- Story fields (StoryArc, StoryArcNumber, SeriesGroup, ScanInformation, Review)

### Integer Fields
- Count, Volume, AlternateCount, PageCount
- Date fields (Year, Month, Day)

### Enum Fields
- BlackAndWhite: `.unknown`, `.no`, `.yes`
- Manga: `.unknown`, `.no`, `.yes`, `.yesAndRightToLeft`
- AgeRating: Various ESRB and international ratings

### Decimal Fields
- CommunityRating: 0.0 to 5.0 range with validation

### Complex Fields
- Pages: Array of `ComicPage` objects with full attribute support
- Page types: `.frontCover`, `.backCover`, `.innerCover`, `.roundup`, `.story`, `.advertisement`, `.editorial`, `.letters`, `.preview`, `.other`, `.deleted`

## Development

### Building

```sh
swift build
```

### Testing

```sh
# Run all tests
swift test

# Run tests with verbose output
swift test --verbose

# Run specific test
swift test --filter testBasicLoading
```

### Code Formatting

This project uses `swift-format` for code formatting:

```sh
# Format all Swift files
swift format --in-place --recursive Sources/ Tests/

# Check formatting
swift format --lint --recursive Sources/ Tests/
```

## Implementation Status

### Current Features ✅
- **Core Reading**: Complete ComicInfo.xml parsing
- **Schema Compliance**: Full ComicInfo v2.0 support
- **Field Types**: String, Int, Double, Enum, Bool, Arrays
- **Multi-value Fields**: Both string and array access methods
- **Issue & Page Support**: Complete Issue and nested Page objects
- **Error Handling**: Swift error types with detailed messages
- **Swift Testing**: Modern Swift Testing framework support
- **Unicode Support**: International characters and special symbols
- **Async Support**: Async/await loading methods

### Planned Features 🚧
- **XML Generation**: Writing ComicInfo.xml files
- **CLI Tool**: Command-line interface for file manipulation
- **Schema Migration**: Support for multiple ComicInfo versions
- **Codable Support**: Full Codable conformance for JSON/PropertyList export

### Schema Versions
- ✅ **ComicInfo v2.0**: Full support (current)
- 🚧 **ComicInfo v2.1**: Planned
- 🚧 **ComicInfo v1.0**: Planned

## Contributing

Bug reports and pull requests are welcome on GitHub.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the code of conduct.

## License

The package is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Acknowledgments

- [Anansi Project](https://github.com/anansi-project/comicinfo) for the ComicInfo schema specification
- [Ruby ComicInfo](https://github.com/veganstraightedge/comicinfo) gem for API inspiration and test cases
