# ComicInfo.Issue

Represents a comic book issue with all metadata.

## Properties

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

## Computed Properties

- `isManga: Bool` - True if manga format
- `isRightToLeft: Bool` - True if right-to-left reading
- `isBlackAndWhite: Bool` - True if black and white
- `hasPages: Bool` - True if pages array is not empty
- `coverPages: [Page]` - Filter to cover pages only
- `storyPages: [Page]` - Filter to story pages only
- `publicationDate: Date?` - Computed publication date

## Methods

- `toJSONString() throws -> String` - Export to JSON string
- `toJSONData() throws -> Data` - Export to JSON data
- `toXMLString() throws -> String` - Export to XML string
