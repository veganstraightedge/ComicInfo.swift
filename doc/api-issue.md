# ComicInfo.Issue

Represents a comic book issue with all metadata.

## Properties

**Basic Info:**

- `title: String?` - Issue title
- `series: String?` - Series name
- `number: String?` - Issue number
- `volume: Int?` - Volume number
- `count: Int?` - Total issues in series
- `year: Int?` - Publication year (1000-9999)
- `month: Int?` - Publication month (1-12)
- `day: Int?` - Publication day (1-31)

**Alternate Series:**

- `alternateSeries: String?` - Alternate series name
- `alternateNumber: String?` - Issue number in the alternate series
- `alternateCount: Int?` - Total issues in the alternate series
- `seriesGroup: String?` - Group the series belongs to

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
- `scanInformation: String?` - Scan information
- `mainCharacterOrTeam: String?` - Main character or team
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

- `storyArc: String?` - Story arc name(s) (comma-separated)
- `storyArcNumber: String?` - Position(s) in arc (comma-separated)
- `storyArcs: [String]` - Parsed story arcs
- `storyArcNumbers: [String]` - Parsed arc positions
- `storyArcsRawData: String?` - Same as `storyArc`
- `storyArcNumbersRawData: String?` - Same as `storyArcNumber`

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
- `publicationDate: Date?` - Computed publication date (missing month or day defaults to 1)

## Methods

- `rearrangingPages(_: [Int?]) -> Issue` - Copy with `pages` and `pageCount` updated after page images were reordered, deleted or added; each element is the image's previous index, or nil if new
- `validate() throws` - Throws `rangeError` if a numeric value is one that loading would reject
- `toJSONString() throws -> String` - Export to JSON string
- `toJSONData() throws -> Data` - Export to JSON data
- `toYAMLString() throws -> String` - Export to YAML string
- `toXMLString() throws -> String` - Export to XML string (calls `validate()` first)
- `save(to: URL) throws` - Write ComicInfo XML to a file URL, creating directories as needed
- `save(to: String) throws` - Write ComicInfo XML to a file path, creating directories as needed

## Static Methods

- `load(fromXML: String) throws -> Issue` - Load from XML string
