# ComicInfo Swift Package

A Swift package for reading and writing ComicInfo.xml files, following ComicInfo schema specifications from the [Anansi Project](https://github.com/anansi-project/comicinfo).

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

## Development

### Running Tests

```bash
swift test
```

### Running Tests on iOS Simulator

```bash
# Generate Xcode project first
swift package generate-xcodeproj

# Run on iOS Simulator
xcodebuild test \
  -project ComicInfo.xcodeproj \
  -scheme ComicInfo-Package \
  -destination "platform=iOS Simulator,name=iPhone 26,OS=26.0"
```

### Code Formatting

This project uses `swift-format` for code formatting:

```bash
# Check formatting
swift-format lint --recursive Sources Tests

# Auto-format code
swift-format format --recursive Sources Tests --in-place
```

### Package Validation

Validate the package structure and dependencies:

```bash
# Describe package structure
swift package describe --type json

# Resolve dependencies
swift package resolve

# Show dependency tree
swift package show-dependencies

# Build in debug mode
swift build --configuration debug

# Build in release mode
swift build --configuration release
```

### Continuous Integration

The project uses GitHub Actions for CI with the following checks:

- **macOS Tests**: Run full test suite on macOS 26
- **iOS Tests**: Run tests on iOS 26 simulators (iPhone and iPad)
- **watchOS Tests**: Run tests on watchOS 26 simulators
- **tvOS Tests**: Run tests on tvOS 26 simulators
- **Code Formatting**: Verify code follows formatting standards
- **Package Validation**: Ensure package can be resolved and built

CI runs on every push to `main` branches and on pull requests.

## Usage

### Loading ComicInfo Files

```swift
import ComicInfo

// Load from file path
let comic = try ComicInfo.load(from: "/path/to/ComicInfo.xml")

// Load from URL
let url = URL(fileURLWithPath: "/path/to/ComicInfo.xml")
let comic = try ComicInfo.load(from: url)

// Load asynchronously (Swift 6.2+)
let comic = try await ComicInfo.load(from: url)

// Load from XML string
let xmlString = """
<ComicInfo>
  <Title>Amazing Spider-Man</Title>
  <Series>Amazing Spider-Man</Series>
  <Number>1</Number>
  <Year>2023</Year>
</ComicInfo>
"""
let comic = try ComicInfo.load(fromXML: xmlString)
```

### Accessing Issue Data

```swift
let issue = try ComicInfo.load(from: "ComicInfo.xml")

// Basic properties
print("Title: \(comic.title ?? "Unknown")")
print("Series: \(comic.series ?? "Unknown")")
print("Issue #: \(comic.number ?? "Unknown")")
print("Year: \(comic.year ?? 0)")

// Creator information
print("Writer: \(comic.writer ?? "Unknown")")
print("Artist: \(comic.penciller ?? "Unknown")")
print("Publisher: \(comic.publisher ?? "Unknown")")

// Multi-value fields (comma-separated in XML)
let genres = comic.genres          // ["Action", "Adventure", "Superhero"]
let characters = comic.characters  // ["Spider-Man", "Peter Parker"]
let locations = comic.locations    // ["New York", "Manhattan"]

// Boolean helpers
if comics.isManga {
  print("This is a manga")
  if comics.isRightToLeft {
    print("Read right-to-left")
  }
}

if comics.isBlackAndWhite {
  print("Black and white comic")
}

// Publication date
if let pubDate = comic.publicationDate {
  print("Published: \(pubDate)")
}
```

### Working with Pages

```swift
let issue = try ComicInfo.load(from: "ComicInfo.xml")

// Check if issue has page information
if comic.hasPages {
  print("Total pages: \(comic.pages.count)")

  // Filter pages by type
  let coverPages = comic.coverPages
  let storyPages = comic.storyPages

  print("Cover pages: \(coverPages.count)")
  print("Story pages: \(storyPages.count)")

  // Access individual pages
  for page in comic.pages {
    print("Page \(page.image): \(page.type)")

    if page.isCover {
      print("  This is a cover page")
    }

    if page.isDoublePage {
      print("  Double-page spread")
    }

    if let (width, height) = page.dimensions,
      page.dimensionsAvailable {
      print("  Size: \(width)x\(height)")
      if let ratio = page.aspectRatio {
        print("  Aspect ratio: \(ratio)")
      }
    }
  }
}
```

### Export Functionality

#### JSON Export

```swift
let comic = try ComicInfo.load(from: "ComicInfo.xml")

// Export to JSON string
let jsonString = try comic.toJSONString()
print(jsonString)

// Export to JSON data
let jsonData = try comic.toJSONData()
try jsonData.write(to: URL(fileURLWithPath: "output.json"))

// Round-trip: JSON -> Issue
let decoder = JSONDecoder()
let reimported = try decoder.decode(ComicInfo.comic.self, from: jsonData)
```

#### XML Export

```swift
let comic = ComicInfo.Issue(
  title: "My Comic",
  series: "My Series",
  number: "1",
  year: 2023,
  writer: "John Doe"
)

// Export to XML string
let xmlString = try comic.toXMLString()
print(xmlString)

// Save to file
try xmlString.write(
  to: URL(fileURLWithPath: "ComicInfo.xml"),
  atomically: true,
  encoding: .utf8
)

// Round-trip: XML -> Issue -> XML
let reimported = try ComicInfo.load(fromXML: xmlString)
let xmlString2 = try reimported.toXMLString()
```

### Error Handling

```swift
do {
  let comic = try ComicInfo.load(from: "ComicInfo.xml")
  print("Loaded: \(comic.title ?? "Unknown")")
} catch ComicInfoError.fileError(let message) {
  print("File error: \(message)")
} catch ComicInfoError.parseError(let message) {
  print("Parse error: \(message)")
} catch ComicInfoError.invalidEnum(let field, let value, let validValues) {
  print("Invalid \(field): '\(value)'. Valid values: \(validValues)")
} catch ComicInfoError.rangeError(let field, let value, let min, let max) {
  print("\(field) value '\(value)' out of range (\(min)..\(max))")
} catch {
  print("Other error: \(error)")
}
```

### Creating Issues Programmatically

```swift
import ComicInfo

// Create a new comic issue
let comic = ComicInfo.Issue(
  ageRating: .teen,
  colorist: "Steve Oliff",
  charactersRawData: "Spider-Man, Peter Parker, Mary Jane Watson",
  communityRating: 4.5,
  count: 100,
  coverArtist: "Todd McFarlane",
  day: 15,
  genreRawData: "Superhero, Action, Adventure",
  inker: "Todd McFarlane",
  languageISO: "en",
  letterer: "Rick Parker",
  locationsRawData: "New York City, Manhattan",
  manga: .no,
  month: 8,
  notes: "First appearance of Venom",
  number: "300",
  pageCount: 22,
  penciller: "Todd McFarlane",
  publisher: "Marvel Comics",
  series: "The Amazing Spider-Man",
  summary: "Spider-Man faces his greatest challenge yet...",
  title: "The Amazing Spider-Man",
  volume: 1,
  writer: "David Michelinie",
  year: 1988,
  pages: [
    ComicInfo.Page(image: 0, type: .frontCover),
    ComicInfo.Page(image: 1, type: .story),
    ComicInfo.Page(image: 2, type: .story),
    // ... more pages
    ComicInfo.Page(image: 21, type: .backCover)
  ]
)

// Export to XML
let xml = try comic.toXMLString()
try xml.write(to: URL(fileURLWithPath: "ComicInfo.xml"),
              atomically: true, encoding: .utf8)
```

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

## Platform Support

- **macOS** 26+ (Tahoe)
- **iOS** 26.0+

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Follow TDD practices - write tests first
4. Ensure all tests pass (`swift test`)
5. Run `swift-format` on your code
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Anansi Project](https://github.com/anansi-project/comicinfo) for ComicInfo schema specification
- [ComicRack](http://comicrack.cyolito.com/) for the original ComicInfo.xml format
