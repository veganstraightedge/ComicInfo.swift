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
let issue = try ComicInfo.load(from: "/path/to/ComicInfo.xml")

// Load from URL
let url = URL(fileURLWithPath: "/path/to/ComicInfo.xml")
let issue = try ComicInfo.load(from: url)

// Load asynchronously (Swift 6.2+)
let issue = try await ComicInfo.load(from: url)

// Load from XML string
let xmlString = """
<ComicInfo>
  <Title>Amazing Spider-Man</Title>
  <Series>Amazing Spider-Man</Series>
  <Number>1</Number>
  <Year>2023</Year>
</ComicInfo>
"""
let issue = try ComicInfo.load(fromXML: xmlString)
```

### Accessing Issue Data

```swift
let issue = try ComicInfo.load(from: "ComicInfo.xml")

// Basic properties
print("Title: \(issue.title ?? "Unknown")")
print("Series: \(issue.series ?? "Unknown")")
print("Issue #: \(issue.number ?? "Unknown")")
print("Year: \(issue.year ?? 0)")

// Creator information
print("Writer: \(issue.writer ?? "Unknown")")
print("Artist: \(issue.penciller ?? "Unknown")")
print("Publisher: \(issue.publisher ?? "Unknown")")

// Multi-value fields (comma-separated in XML)
let genres = issue.genres  // ["Action", "Adventure", "Superhero"]
let characters = issue.characters  // ["Spider-Man", "Peter Parker"]
let locations = issue.locations  // ["New York", "Manhattan"]

// Boolean helpers
if issue.isManga {
    print("This is a manga")
    if issue.isRightToLeft {
        print("Read right-to-left")
    }
}

if issue.isBlackAndWhite {
    print("Black and white comic")
}

// Publication date
if let pubDate = issue.publicationDate {
    print("Published: \(pubDate)")
}
```

### Working with Pages

```swift
let issue = try ComicInfo.load(from: "ComicInfo.xml")

// Check if issue has page information
if issue.hasPages {
    print("Total pages: \(issue.pages.count)")
    
    // Filter pages by type
    let coverPages = issue.coverPages
    let storyPages = issue.storyPages
    
    print("Cover pages: \(coverPages.count)")
    print("Story pages: \(storyPages.count)")
    
    // Access individual pages
    for page in issue.pages {
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
let issue = try ComicInfo.load(from: "ComicInfo.xml")

// Export to JSON string
let jsonString = try issue.toJSONString()
print(jsonString)

// Export to JSON data
let jsonData = try issue.toJSONData()
try jsonData.write(to: URL(fileURLWithPath: "output.json"))

// Round-trip: JSON -> Issue
let decoder = JSONDecoder()
let reimported = try decoder.decode(ComicInfo.Issue.self, from: jsonData)
```

#### XML Export

```swift
let issue = ComicInfo.Issue(
    title: "My Comic",
    series: "My Series", 
    number: "1",
    year: 2023,
    writer: "John Doe"
)

// Export to XML string
let xmlString = try issue.toXMLString()
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
    let issue = try ComicInfo.load(from: "ComicInfo.xml")
    print("Loaded: \(issue.title ?? "Unknown")")
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
let issue = ComicInfo.Issue(
    ageRating: .teen,
    charactersRawData: "Spider-Man, Peter Parker, Mary Jane Watson",
    colorist: "Steve Oliff",
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
let xml = try issue.toXMLString()
try xml.write(to: URL(fileURLWithPath: "MyComic.xml"), 
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
- `.unknown`, `.adultsOnly18Plus`, `.earlyChildhood`, `.everyone`, `.everyone10Plus`, `.g`, `.kidsToAdults`, `.m`, `.ma15Plus`, `.mature17Plus`, `.pg`, `.r18Plus`, `.ratingPending`, `.teen`, `.x18Plus`

#### Manga  
- `.unknown`, `.no`, `.yes`, `.yesAndRightToLeft`

#### BlackAndWhite
- `.unknown`, `.no`, `.yes`

#### PageType
- `.frontCover`, `.innerCover`, `.roundup`, `.story`, `.advertisement`, `.editorial`, `.letters`, `.preview`, `.backCover`, `.other`, `.deleted`

### Error Types

All errors conform to `ComicInfoError` enum:

- `.fileError(String)` - File access errors
- `.parseError(String)` - XML parsing errors
- `.invalidEnum(field:value:validValues:)` - Invalid enum values
- `.rangeError(field:value:min:max:)` - Numeric range violations
- `.typeCoercionError(field:value:expectedType:)` - Type conversion errors  
- `.schemaError(String)` - Schema validation errors

## Platform Support

- **macOS** 10.15+ (Catalina)
- **iOS** 13.0+
- **watchOS** 6.0+
- **tvOS** 13.0+
- **Linux** (Swift 6.2+)

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
- Ruby gem [comicinfo-ruby](https://github.com/your-org/comicinfo-ruby) for reference implementation
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
