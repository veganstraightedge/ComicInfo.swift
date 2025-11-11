//
// ComicInfo.swift
// ComicInfo
//
// A Swift package for reading and writing ComicInfo.xml metadata files.
//
// This package provides a complete implementation of the ComicInfo v2.0 schema
// for parsing and generating comic book metadata XML files.
//

import Foundation

/// String extension for handling empty values in ComicInfo parsing
extension String {
  /// Returns nil if the string is empty, otherwise returns self
  /// Used internally to convert empty XML text content to nil values
  fileprivate var nilIfEmpty: String? {
    return self.isEmpty ? nil : self
  }
}

/// Errors that can occur during ComicInfo parsing and processing.
///
/// All ComicInfo operations throw errors conforming to this enum, providing
/// detailed information about what went wrong and how to fix it.
///
/// ## Usage
/// ```swift
/// do {
///   let issue = try ComicInfo.load(from: "ComicInfo.xml")
/// } catch ComicInfoError.fileError(let message) {
///   print("File error: \(message)")
/// } catch ComicInfoError.parseError(let message) {
///   print("Parse error: \(message)")
/// }
/// ```
public enum ComicInfoError: Error, Equatable {
  /// XML parsing failed due to malformed XML or missing required elements
  case parseError(String)

  /// File system error occurred (file not found, permission denied, etc.)
  case fileError(String)

  /// Invalid value for an enum field with list of valid values
  case invalidEnum(field: String, value: String, validValues: [String])

  /// Numeric value outside allowed range
  case rangeError(field: String, value: String, min: String, max: String)

  /// Cannot convert string value to expected type (Int, Double, etc.)
  case typeCoercionError(field: String, value: String, expectedType: String)

  /// ComicInfo schema validation error
  case schemaError(String)
}

extension ComicInfoError: LocalizedError {
  /// Localized error message describing what went wrong.
  public var errorDescription: String? {
    switch self {
    case .parseError(let message):
      return "Parse error: \(message)"
    case .fileError(let message):
      return "File error: \(message)"
    case .invalidEnum(let field, let value, let validValues):
      return "Invalid value '\(value)' for field '\(field)'. Valid values are: \(validValues.joined(separator: ", "))"
    case .rangeError(let field, let value, let min, let max):
      return "Value '\(value)' for field '\(field)' is out of range (\(min)..\(max))"
    case .typeCoercionError(let field, let value, let expectedType):
      return "Cannot convert value '\(value)' for field '\(field)' to \(expectedType)"
    case .schemaError(let message):
      return "Schema error: \(message)"
    }
  }
}

extension ComicInfo {
  fileprivate static func validateCommunityRating(_ value: String) throws -> Double {
    guard let rating = Double(value) else {
      throw ComicInfoError.typeCoercionError(field: "CommunityRating", value: value, expectedType: "Double")
    }
    if !(0.0...5.0).contains(rating) {
      throw ComicInfoError.rangeError(field: "CommunityRating", value: value, min: "0.0", max: "5.0")
    }
    return rating
  }

  fileprivate static func validateYear(_ value: String) throws -> Int {
    guard let year = Int(value) else {
      throw ComicInfoError.typeCoercionError(field: "Year", value: value, expectedType: "Int")
    }
    if !(1000...9999).contains(year) {
      throw ComicInfoError.rangeError(field: "Year", value: value, min: "1000", max: "9999")
    }
    return year
  }

  fileprivate static func validateMonth(_ value: String) throws -> Int {
    let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      return 0  // Default value for empty strings
    }
    guard let month = Int(trimmed) else {
      throw ComicInfoError.typeCoercionError(field: "Month", value: value, expectedType: "Int")
    }
    if !(1...12).contains(month) {
      throw ComicInfoError.rangeError(field: "Month", value: value, min: "1", max: "12")
    }
    return month
  }

  fileprivate static func validateDay(_ value: String) throws -> Int {
    let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      return 0  // Default value for empty strings
    }
    guard let day = Int(trimmed) else {
      throw ComicInfoError.typeCoercionError(field: "Day", value: value, expectedType: "Int")
    }
    if !(1...31).contains(day) {
      throw ComicInfoError.rangeError(field: "Day", value: value, min: "1", max: "31")
    }
    return day
  }
}

/// Main entry point for loading ComicInfo data.
public enum ComicInfo {

  /// Version information for the ComicInfo.swift.
  public enum Version {
    /// The current version of the ComicInfo.swift.
    public static let current = "1.0.1"
  }

  /// Manga enum representing manga reading direction.
  public enum Manga: String, CaseIterable, Equatable, Codable {
    case unknown = "Unknown"
    case no = "No"
    case yes = "Yes"
    case yesAndRightToLeft = "YesAndRightToLeft"

    /// String value for XML serialization.
    public var stringValue: String {
      return self.rawValue
    }

    /// Create from string, defaulting to unknown for invalid values.
    public static func from(string: String?) -> Manga {
      guard let string = string, !string.isEmpty else {
        return .unknown
      }
      return Manga(rawValue: string) ?? .unknown
    }

    /// Create from string with validation (throws on invalid values).
    public static func validated(from string: String) throws -> Manga {
      guard let manga = Manga(rawValue: string) else {
        throw ComicInfoError.invalidEnum(
          field: "Manga",
          value: string,
          validValues: Manga.allCases.map { $0.stringValue }
        )
      }
      return manga
    }

    /// True if this represents a manga (Yes or YesAndRightToLeft).
    public var isManga: Bool {
      return self == .yes || self == .yesAndRightToLeft
    }

    /// True if this represents right-to-left reading direction.
    public var isRightToLeft: Bool {
      return self == .yesAndRightToLeft
    }
  }

  /// Age rating classification for content appropriateness.
  ///
  /// Provides standardized age ratings compatible with various rating systems
  /// including ESRB, PEGI, and regional classification standards.
  ///
  /// ## Common Values
  /// - `.everyone`: Suitable for all ages
  /// - `.teen`: 13+ content
  /// - `.mature17Plus`: 17+ mature content
  /// - `.adultsOnly18Plus`: 18+ adult content only
  public enum AgeRating: String, CaseIterable, Equatable, Codable {
    case unknown = "Unknown"
    case adultsOnly18Plus = "Adults Only 18+"
    case earlyChildhood = "Early Childhood"
    case everyone = "Everyone"
    case everyone10Plus = "Everyone 10+"
    case g = "G"
    case kidsToAdults = "Kids to Adults"
    case m = "M"
    case ma15Plus = "MA15+"
    case mature17Plus = "Mature 17+"
    case pg = "PG"
    case r18Plus = "R18+"
    case ratingPending = "Rating Pending"
    case teen = "Teen"
    case x18Plus = "X18+"

    /// String value for XML serialization.
    public var stringValue: String {
      return self.rawValue
    }

    /// Create from string, defaulting to unknown for invalid values.
    public static func from(string: String?) -> AgeRating {
      guard let string = string, !string.isEmpty else {
        return .unknown
      }
      return AgeRating(rawValue: string) ?? .unknown
    }

    /// Create from string with validation (throws on invalid values).
    public static func validated(from string: String) throws -> AgeRating {
      guard let rating = AgeRating(rawValue: string) else {
        throw ComicInfoError.invalidEnum(
          field: "AgeRating",
          value: string,
          validValues: AgeRating.allCases.map { $0.stringValue }
        )
      }
      return rating
    }
  }

  /// Color format designation for the comic content.
  ///
  /// Indicates whether the comic is published in color or black & white.
  /// Used for filtering and display preferences in reading applications.
  ///
  /// ## Values
  /// - `.unknown`: Color format not specified
  /// - `.no`: Full color comic
  /// - `.yes`: Black and white comic
  public enum BlackAndWhite: String, CaseIterable, Equatable, Codable {
    case unknown = "Unknown"
    case no = "No"
    case yes = "Yes"

    /// String value for XML serialization.
    public var stringValue: String {
      return self.rawValue
    }

    /// Create from string, defaulting to unknown for invalid values.
    public static func from(string: String?) -> BlackAndWhite {
      guard let string = string, !string.isEmpty else {
        return .unknown
      }
      return BlackAndWhite(rawValue: string) ?? .unknown
    }

    /// Create from string with validation (throws on invalid values).
    public static func validated(from string: String) throws -> BlackAndWhite {
      guard let blackAndWhite = BlackAndWhite(rawValue: string) else {
        throw ComicInfoError.invalidEnum(
          field: "BlackAndWhite",
          value: string,
          validValues: BlackAndWhite.allCases.map { $0.stringValue }
        )
      }
      return blackAndWhite
    }

    /// True if this represents black and white.
    public var isBlackAndWhite: Bool {
      return self == .yes
    }
  }

  /// Page type enum for comic pages.
  public enum PageType: String, CaseIterable, Equatable, Codable {
    case frontCover = "FrontCover"
    case innerCover = "InnerCover"
    case roundup = "Roundup"
    case story = "Story"
    case advertisement = "Advertisement"
    case editorial = "Editorial"
    case letters = "Letters"
    case preview = "Preview"
    case backCover = "BackCover"
    case other = "Other"
    case deleted = "Deleted"

    /// String value for XML serialization.
    public var stringValue: String {
      return self.rawValue
    }

    /// Create from string, defaulting to story for invalid values.
    public static func from(string: String?) -> PageType {
      guard let string = string, !string.isEmpty else {
        return .story
      }
      return PageType(rawValue: string) ?? .story
    }

    /// Create from string with validation (throws on invalid values).
    public static func validated(from string: String) throws -> PageType {
      guard let pageType = PageType(rawValue: string) else {
        throw ComicInfoError.invalidEnum(
          field: "PageType",
          value: string,
          validValues: PageType.allCases.map { $0.stringValue }
        )
      }
      return pageType
    }

    /// True if this is a cover page type.
    public var isCover: Bool {
      return self == .frontCover || self == .backCover || self == .innerCover
    }

    /// True if this is a story page.
    public var isStory: Bool {
      return self == .story
    }

    /// True if this page is deleted.
    public var isDeleted: Bool {
      return self == .deleted
    }
  }

  /// Represents a single page in a comic book with metadata.
  public struct Page: Equatable, Hashable, Codable {
    /// Page number or index (0-based)
    public let image: Int

    /// Type classification of this page
    public let type: PageType

    /// True if this is a double-page spread
    public let doublePage: Bool

    /// File size in bytes (0 if unknown)
    public let imageSize: Int

    /// Optional key or identifier for the page
    public let key: String

    /// Bookmark text or annotation for the page
    public let bookmark: String

    /// Image width in pixels (-1 if unknown)
    public let imageWidth: Int

    /// Image height in pixels (-1 if unknown)
    public let imageHeight: Int

    /// Initialize a new Page with the specified attributes.
    ///
    /// ## Usage
    /// ```swift
    /// let coverPage = ComicInfo.Page(image: 0, type: .frontCover)
    /// let storyPage = ComicInfo.Page(image: 1, type: .story, doublePage: true)
    /// ```
    ///
    /// - Parameters:
    ///   - image: Page number/index (0-based)
    ///   - type: Page type classification (defaults to .story)
    ///   - doublePage: True if this is a double-page spread (defaults to false)
    ///   - imageSize: File size in bytes (defaults to 0)
    ///   - key: Key/identifier string (defaults to empty)
    ///   - bookmark: Bookmark text (defaults to empty)
    ///   - imageWidth: Image width in pixels (defaults to -1 for unknown)
    ///   - imageHeight: Image height in pixels (defaults to -1 for unknown)
    public init(
      image: Int,
      type: PageType = .story,
      doublePage: Bool = false,
      imageSize: Int = 0,
      key: String = "",
      bookmark: String = "",
      imageWidth: Int = -1,
      imageHeight: Int = -1
    ) {
      self.image = image
      self.type = type
      self.doublePage = doublePage
      self.imageSize = imageSize
      self.key = key
      self.bookmark = bookmark
      self.imageWidth = imageWidth
      self.imageHeight = imageHeight
    }

    /// True if this page is a cover page.
    public var isCover: Bool {
      return type.isCover
    }

    /// True if this page is a story page.
    public var isStory: Bool {
      return type.isStory
    }

    /// True if this page is deleted.
    public var isDeleted: Bool {
      return type.isDeleted
    }

    /// True if this is a double-page spread.
    public var isDoublePage: Bool {
      return doublePage
    }

    /// True if this page has a bookmark.
    public var isBookmarked: Bool {
      return !bookmark.isEmpty
    }

    /// Get image dimensions as optional values.
    public var dimensions: (width: Int?, height: Int?) {
      let width = imageWidth == -1 ? nil : imageWidth
      let height = imageHeight == -1 ? nil : imageHeight
      return (width: width, height: height)
    }

    /// True if both width and height dimensions are available.
    public var dimensionsAvailable: Bool {
      return imageWidth != -1 && imageHeight != -1
    }

    /// Calculate aspect ratio if dimensions are available.
    public var aspectRatio: Double? {
      guard dimensionsAvailable, imageHeight != 0 else {
        return nil
      }
      return Double(imageWidth) / Double(imageHeight)
    }
  }

  /// Load ComicInfo from an XML string.
  ///
  /// Parses ComicInfo XML content directly from a string, validating
  /// all fields according to the ComicInfo v2.0 schema.
  ///
  /// ## Usage
  /// ```swift
  /// let xml = """
  /// <ComicInfo>
  ///   <Title>Amazing Spider-Man</Title>
  ///   <Series>Amazing Spider-Man</Series>
  ///   <Number>1</Number>
  /// </ComicInfo>
  /// """
  /// let issue = try ComicInfo.load(fromXML: xml)
  /// ```
  ///
  /// - Parameter xmlString: Valid ComicInfo XML content
  /// - Returns: Parsed Issue with all metadata
  /// - Throws: ComicInfoError.parseError for invalid XML or schema violations
  public static func load(fromXML xmlString: String) throws -> Issue {
    return try Issue.load(fromXML: xmlString)
  }

  /// Load ComicInfo from a file path or XML string (smart detection).
  ///
  /// Automatically detects whether the input is a file path or XML content
  /// based on the string format, then loads appropriately.
  ///
  /// ## Detection Logic
  /// - Strings starting with `<` are treated as XML content
  /// - All other strings are treated as file paths
  ///
  /// ## Usage
  /// ```swift
  /// // Load from file path
  /// let issue1 = try ComicInfo.load(from: "/path/to/ComicInfo.xml")
  ///
  /// // Load from XML string
  /// let issue2 = try ComicInfo.load(from: "<ComicInfo><Title>Test</Title></ComicInfo>")
  /// ```
  ///
  /// - Parameter input: File path or XML string
  /// - Returns: Parsed Issue with all metadata
  /// - Throws: ComicInfoError for file access or parsing errors
  public static func load(from input: String) throws -> Issue {
    guard !input.isEmpty else {
      throw ComicInfoError.parseError("Input cannot be nil or empty")
    }

    guard looksLikeXML(input) else {
      return try loadFromFile(input)
    }
    return try load(fromXML: input)
  }

  /// Load ComicInfo from a URL.
  ///
  /// Synchronously loads and parses ComicInfo XML from a file URL.
  /// The file content is read as UTF-8 encoded text.
  ///
  /// ## Usage
  /// ```swift
  /// let url = URL(fileURLWithPath: "/path/to/ComicInfo.xml")
  /// let issue = try ComicInfo.load(from: url)
  /// ```
  ///
  /// - Parameter url: File URL pointing to ComicInfo.xml
  /// - Returns: Parsed Issue with all metadata
  /// - Throws: ComicInfoError.fileError for file access issues, parseError for XML issues
  public static func load(from url: URL) throws -> Issue {
    do {
      let xmlContent = try String(contentsOf: url, encoding: .utf8)
      return try load(fromXML: xmlContent)
    } catch let error as ComicInfoError {
      // Re-throw ComicInfo errors
      throw error
    } catch {
      throw ComicInfoError.fileError("Failed to read from URL '\(url)': \(error.localizedDescription)")
    }
  }

  /// Load ComicInfo from a URL asynchronously.
  ///
  /// Asynchronously loads and parses ComicInfo XML from any URL using URLSession.
  /// Supports both local file URLs and remote HTTP/HTTPS URLs.
  ///
  /// ## Usage
  /// ```swift
  /// let url = URL(string: "https://example.com/ComicInfo.xml")!
  /// let issue = try await ComicInfo.load(from: url)
  /// ```
  ///
  /// - Parameter url: Local file URL or remote HTTP/HTTPS URL
  /// - Returns: Parsed Issue with all metadata
  /// - Throws: ComicInfoError.fileError for network/file issues, parseError for XML issues
  @available(macOS 26, iOS 26, watchOS 26, tvOS 26, *)
  public static func load(from url: URL) async throws -> Issue {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      guard let xmlContent = String(data: data, encoding: .utf8) else {
        throw ComicInfoError.parseError("Could not decode data from URL '\(url)' as UTF-8")
      }
      return try load(fromXML: xmlContent)
    } catch let error as ComicInfoError {
      // Re-throw ComicInfo errors
      throw error
    } catch {
      throw ComicInfoError.fileError("Failed to load from URL '\(url)': \(error.localizedDescription)")
    }
  }

  /// Check if input looks like XML (starts with <).
  private static func looksLikeXML(_ input: String) -> Bool {
    return input.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("<")
  }

  /// Load from file path.
  private static func loadFromFile(_ filePath: String) throws -> Issue {
    try validateFilePath(filePath)

    guard FileManager.default.fileExists(atPath: filePath) else {
      throw ComicInfoError.fileError("File does not exist: '\(filePath)'")
    }

    do {
      let xmlContent = try String(contentsOfFile: filePath, encoding: .utf8)
      return try load(fromXML: xmlContent)
    } catch let error as ComicInfoError {
      // Re-throw ComicInfo errors
      throw error
    } catch {
      throw ComicInfoError.fileError("Failed to read file '\(filePath)': \(error.localizedDescription)")
    }
  }

  /// Validate file path to ensure it's not ambiguous with XML.
  private static func validateFilePath(_ input: String) throws {
    // Check for patterns that might be mistaken for XML or are clearly invalid paths
    if input.range(of: "^\\d+$", options: .regularExpression) != nil
      || (!input.contains(".") && !input.contains("/") && !input.contains("\\"))
    {
      throw ComicInfoError.parseError("Input '\(input)' does not appear to be valid XML or a file path")
    }
  }

  /// Represents a comic book issue with metadata from ComicInfo.xml.
  ///
  /// This structure contains all the metadata fields defined in the ComicInfo v2.0 schema,
  /// including publication information, creator details, story metadata, and page information.
  ///
  /// ## Loading ComicInfo Data
  /// ```swift
  /// // Load from XML string
  /// let issue = try ComicInfo.load(fromXML: xmlString)
  ///
  /// // Load from file path
  /// let issue = try ComicInfo.load(from: filePath)
  ///
  /// // Load from URL
  /// let issue = try ComicInfo.load(from: url)
  /// ```
  ///
  /// ## Accessing Multi-value Fields
  /// Multi-value fields provide both raw string access and parsed array access:
  /// ```swift
  /// let genreString = issue.genreRawData    // "Action, Adventure, Superhero"
  /// let genreArray = issue.genres           // ["Action", "Adventure", "Superhero"]
  /// ```
  public struct Issue: Codable {
    /// Age rating classification for content appropriateness.
    public let ageRating: AgeRating?
    /// Total issues in alternate series.
    public let alternateCount: Int?
    /// Issue number in alternate series.
    public let alternateNumber: String?
    /// Alternate series name for crossovers.
    public let alternateSeries: String?
    /// Color format designation (color vs black & white).
    public let blackAndWhite: BlackAndWhite?
    /// Comma-separated character names appearing in this issue.
    public let charactersRawData: String?
    /// Colorist name(s) who applied color to the artwork.
    public let colorist: String?
    /// Community rating score from 0.0 to 5.0.
    public let communityRating: Double?
    /// Total number of issues in the series.
    public let count: Int?
    /// Cover artist name(s) who created the cover artwork.
    public let coverArtist: String?
    /// Publication day of the month (1-31).
    public let day: Int?
    /// Editor name(s) who supervised the issue creation.
    public let editor: String?
    /// Publication format (e.g., "Digital", "Print").
    public let format: String?
    /// Comma-separated genre classifications.
    public let genreRawData: String?
    /// Publisher imprint or subsidiary label.
    public let imprint: String?
    /// Inker name(s) who outlined the pencil artwork.
    public let inker: String?
    /// Language code in ISO format (e.g., "en-US", "ja-JP").
    public let languageISO: String?
    /// Letterer name(s) who added text and speech bubbles.
    public let letterer: String?
    /// Comma-separated location names where the story takes place.
    public let locationsRawData: String?
    /// Primary character or team featured in this issue.
    public let mainCharacterOrTeam: String?
    /// Manga reading direction and format designation.
    public let manga: Manga?
    /// Publication month (1-12).
    public let month: Int?
    /// Additional notes about the issue or scan.
    public let notes: String?
    /// Issue number within the series.
    public let number: String?
    /// Total number of pages in the issue.
    public let pageCount: Int?
    /// Penciller name(s) who drew the initial artwork.
    public let penciller: String?
    /// Publisher name who released the issue.
    public let publisher: String?
    /// Review text or critique of the issue.
    public let review: String?
    /// Information about the digital scan process.
    public let scanInformation: String?
    /// Series name that this issue belongs to.
    public let series: String?
    /// Series group or universe classification.
    public let seriesGroup: String?
    /// Story arc name(s) that this issue is part of.
    public let storyArc: String?
    /// Story arc number(s) indicating position within arcs.
    public let storyArcNumber: String?
    /// Plot summary or description of the issue content.
    public let summary: String?
    /// Comma-separated team names appearing in this issue.
    public let teamsRawData: String?
    /// Issue title or name.
    public let title: String?
    /// Translator name(s) for localized versions.
    public let translator: String?
    /// Volume number for series with multiple volumes.
    public let volume: Int?
    /// Space-separated web URLs related to this issue.
    public let webRawData: String?
    /// Writer name(s) who created the story.
    public let writer: String?
    /// Publication year.
    public let year: Int?
    /// Array of page information with metadata for each page.
    public let pages: [Page]

    private enum CodingKeys: String, CodingKey {
      case ageRating, alternateCount, alternateNumber, alternateSeries
      case blackAndWhite, charactersRawData, colorist, communityRating
      case count, coverArtist, day, editor, format, genreRawData
      case imprint, inker, languageISO, letterer, locationsRawData
      case mainCharacterOrTeam, manga, month, notes, number, pageCount
      case penciller, publisher, review, scanInformation, series
      case seriesGroup, storyArc, storyArcNumber, summary, teamsRawData
      case title, translator, volume, webRawData, writer, year, pages
    }

    /// Initialize a new Issue with the specified comic metadata.
    ///
    /// Creates a comic issue with all ComicInfo v2.0 schema fields. All parameters
    /// are optional and default to nil or empty arrays as appropriate.
    ///
    /// ## Usage
    /// ```swift
    /// // Minimal comic
    /// let comic = ComicInfo.Issue(
    ///   title: "Amazing Spider-Man",
    ///   series: "Amazing Spider-Man",
    ///   number: "1",
    ///   year: 2018
    /// )
    ///
    /// // Detailed comic with pages
    /// let detailedComic = ComicInfo.Issue(
    ///   title: "My Comic",
    ///   series: "My Series",
    ///   writer: "John Doe",
    ///   penciller: "Jane Smith",
    ///   publisher: "Example Comics",
    ///   year: 2023,
    ///   pages: [
    ///     ComicInfo.Page(image: 0, type: .frontCover),
    ///     ComicInfo.Page(image: 1, type: .story)
    ///   ]
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - ageRating: Content age rating classification
    ///   - alternateCount: Total issues in alternate series
    ///   - alternateNumber: Issue number in alternate series
    ///   - alternateSeries: Alternate series name
    ///   - blackAndWhite: Color format designation
    ///   - charactersRawData: Comma-separated character names
    ///   - colorist: Colorist name(s)
    ///   - communityRating: Community rating (0.0-5.0)
    ///   - count: Total issues in series
    ///   - coverArtist: Cover artist name(s)
    ///   - day: Publication day (1-31)
    ///   - editor: Editor name(s)
    ///   - format: Publication format
    ///   - genreRawData: Comma-separated genre names
    ///   - imprint: Publisher imprint
    ///   - inker: Inker name(s)
    ///   - languageISO: Language code (e.g., "en-US")
    ///   - letterer: Letterer name(s)
    ///   - locationsRawData: Comma-separated location names
    ///   - mainCharacterOrTeam: Primary character or team
    ///   - manga: Manga reading direction
    ///   - month: Publication month (1-12)
    ///   - notes: Additional notes
    ///   - number: Issue number
    ///   - pageCount: Total page count
    ///   - penciller: Penciller name(s)
    ///   - publisher: Publisher name
    ///   - review: Review text
    ///   - scanInformation: Scan details
    ///   - series: Series name
    ///   - seriesGroup: Series group classification
    ///   - storyArc: Story arc name(s)
    ///   - storyArcNumber: Story arc number(s)
    ///   - summary: Story summary
    ///   - teamsRawData: Comma-separated team names
    ///   - title: Issue title
    ///   - translator: Translator name(s)
    ///   - volume: Volume number
    ///   - webRawData: Space-separated web URLs
    ///   - writer: Writer name(s)
    ///   - year: Publication year
    ///   - pages: Array of page information
    public init(
      ageRating: AgeRating? = nil,
      alternateCount: Int? = nil,
      alternateNumber: String? = nil,
      alternateSeries: String? = nil,
      blackAndWhite: BlackAndWhite? = nil,
      charactersRawData: String? = nil,
      colorist: String? = nil,
      communityRating: Double? = nil,
      count: Int? = nil,
      coverArtist: String? = nil,
      day: Int? = nil,
      editor: String? = nil,
      format: String? = nil,
      genreRawData: String? = nil,
      imprint: String? = nil,
      inker: String? = nil,
      languageISO: String? = nil,
      letterer: String? = nil,
      locationsRawData: String? = nil,
      mainCharacterOrTeam: String? = nil,
      manga: Manga? = nil,
      month: Int? = nil,
      notes: String? = nil,
      number: String? = nil,
      pageCount: Int? = nil,
      penciller: String? = nil,
      publisher: String? = nil,
      review: String? = nil,
      scanInformation: String? = nil,
      series: String? = nil,
      seriesGroup: String? = nil,
      storyArc: String? = nil,
      storyArcNumber: String? = nil,
      summary: String? = nil,
      teamsRawData: String? = nil,
      title: String? = nil,
      translator: String? = nil,
      volume: Int? = nil,
      webRawData: String? = nil,
      writer: String? = nil,
      year: Int? = nil,
      pages: [Page] = []
    ) {
      self.ageRating = ageRating
      self.alternateCount = alternateCount
      self.alternateNumber = alternateNumber
      self.alternateSeries = alternateSeries
      self.blackAndWhite = blackAndWhite
      self.charactersRawData = charactersRawData
      self.colorist = colorist
      self.communityRating = communityRating
      self.count = count
      self.coverArtist = coverArtist
      self.day = day
      self.editor = editor
      self.format = format
      self.genreRawData = genreRawData
      self.imprint = imprint
      self.inker = inker
      self.languageISO = languageISO
      self.letterer = letterer
      self.locationsRawData = locationsRawData
      self.mainCharacterOrTeam = mainCharacterOrTeam
      self.manga = manga
      self.month = month
      self.notes = notes
      self.number = number
      self.pageCount = pageCount
      self.penciller = penciller
      self.publisher = publisher
      self.review = review
      self.scanInformation = scanInformation
      self.series = series
      self.seriesGroup = seriesGroup
      self.storyArc = storyArc
      self.storyArcNumber = storyArcNumber
      self.summary = summary
      self.teamsRawData = teamsRawData
      self.title = title
      self.translator = translator
      self.volume = volume
      self.webRawData = webRawData
      self.writer = writer
      self.year = year
      self.pages = pages
    }

    /// Array of characters split from comma-separated string.
    ///
    /// Splits the `charactersRawData` string on commas and trims whitespace.
    /// Empty entries are filtered out.
    /// - Returns: Array of character names, or empty array if no characters.
    public var characters: [String] {
      return splitCommaSeparated(charactersRawData)
    }

    /// Array of teams split from comma-separated string.
    ///
    /// Splits the `teamsRawData` string on commas and trims whitespace.
    /// Empty entries are filtered out.
    /// - Returns: Array of team names, or empty array if no teams.
    public var teams: [String] {
      return splitCommaSeparated(teamsRawData)
    }

    /// Array of locations split from comma-separated string.
    ///
    /// Splits the `locationsRawData` string on commas and trims whitespace.
    /// Empty entries are filtered out.
    /// - Returns: Array of location names, or empty array if no locations.
    public var locations: [String] {
      return splitCommaSeparated(locationsRawData)
    }

    /// Array of genres split from comma-separated string.
    ///
    /// Splits the `genreRawData` string on commas and trims whitespace.
    /// Empty entries are filtered out.
    /// - Returns: Array of genre names, or empty array if no genres.
    public var genres: [String] {
      return splitCommaSeparated(genreRawData)
    }

    /// Array of web URLs split from whitespace-separated string.
    ///
    /// Splits the `webRawData` string on whitespace and converts to URL objects.
    /// Invalid URLs are filtered out.
    /// - Returns: Array of valid URLs, or empty array if no valid URLs.
    public var webUrls: [URL] {
      guard let web = webRawData, !web.isEmpty else {
        return []
      }
      return web.split(separator: " ").compactMap { URL(string: String($0)) }
    }

    /// True if this issue has pages.
    /// - Returns: `true` if the pages array is not empty, `false` otherwise.
    public var hasPages: Bool {
      return !pages.isEmpty
    }

    /// Get only cover pages from the pages array.
    ///
    /// Filters pages to include only those with cover page types (FrontCover, BackCover, InnerCover).
    /// - Returns: Array of cover pages, or empty array if no cover pages.
    public var coverPages: [Page] {
      return pages.filter { $0.isCover }
    }

    /// Get only story pages from the pages array.
    ///
    /// Filters pages to include only those with Story page type.
    /// - Returns: Array of story pages, or empty array if no story pages.
    public var storyPages: [Page] {
      return pages.filter { $0.isStory }
    }

    /// Array of story arcs split from comma-separated string.
    ///
    /// Splits the `storyArc` string on commas and trims whitespace.
    /// Empty entries are filtered out.
    /// - Returns: Array of story arc names, or empty array if no story arcs.
    public var storyArcs: [String] {
      return splitCommaSeparated(storyArc)
    }

    /// Array of story arc numbers split from comma-separated string.
    ///
    /// Splits the `storyArcNumber` string on commas and trims whitespace.
    /// Empty entries are filtered out.
    /// - Returns: Array of story arc numbers, or empty array if no story arc numbers.
    public var storyArcNumbers: [String] {
      return splitCommaSeparated(storyArcNumber)
    }

    /// Raw data access methods for compatibility with Ruby API.
    public var storyArcsRawData: String? { return storyArc }
    /// Raw story arc numbers as comma-separated string for compatibility.
    public var storyArcNumbersRawData: String? { return storyArcNumber }

    /// True if this issue is a manga (Yes or YesAndRightToLeft).
    /// - Returns: `true` if manga field is Yes or YesAndRightToLeft, `false` otherwise.
    public var isManga: Bool {
      return manga?.isManga == true
    }

    /// True if this issue uses right-to-left reading direction.
    /// - Returns: `true` if manga field is YesAndRightToLeft, `false` otherwise.
    public var isRightToLeft: Bool {
      return manga?.isRightToLeft == true
    }

    /// True if this issue is black and white.
    /// - Returns: `true` if blackAndWhite field is Yes, `false` otherwise.
    public var isBlackAndWhite: Bool {
      return blackAndWhite?.isBlackAndWhite == true
    }

    /// Get publication date as Date object if available.
    ///
    /// Uses year, month, day fields with defaults for missing components.
    /// Missing month defaults to 1 (January), missing day defaults to 1.
    /// - Returns: Date object if year is available and valid, nil otherwise.
    public var publicationDate: Date? {
      guard let year = year, year > 0 else {
        return nil
      }

      let month = self.month ?? 1
      let day = self.day ?? 1

      let components = DateComponents(year: year, month: month, day: day)
      return Calendar.current.date(from: components)
    }

    /// Export to JSON Data.
    /// - Returns: JSON Data representation of the Issue
    /// - Throws: EncodingError if the Issue cannot be encoded
    public func toJSONData() throws -> Data {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      encoder.dateEncodingStrategy = .iso8601
      return try encoder.encode(self)
    }

    /// Export to JSON String.
    /// - Returns: JSON String representation of the Issue
    /// - Throws: EncodingError if the Issue cannot be encoded
    public func toJSONString() throws -> String {
      let data = try toJSONData()
      guard let string = String(data: data, encoding: .utf8) else {
        throw ComicInfoError.parseError("Failed to convert JSON data to string")
      }
      return string
    }

    /// Export to XML String in ComicInfo format.
    ///
    /// Generates a complete ComicInfo.xml document with proper schema attributes
    /// and all non-nil properties. The output is compatible with ComicRack and
    /// other applications that support the ComicInfo standard.
    ///
    /// ## Usage
    /// ```swift
    /// let issue = ComicInfo.Issue(title: "My Comic", series: "My Series")
    /// let xmlString = try issue.toXMLString()
    /// try xmlString.write(to: URL(fileURLWithPath: "ComicInfo.xml"),
    ///                    atomically: true, encoding: .utf8)
    /// ```
    ///
    /// ## Round-trip Support
    /// The generated XML can be parsed back into an Issue:
    /// ```swift
    /// let xml = try issue.toXMLString()
    /// let roundTrip = try ComicInfo.load(fromXML: xml)
    /// ```
    ///
    /// - Returns: XML String representation of the Issue
    /// - Throws: ComicInfoError.parseError if XML generation fails
    public func toXMLString() throws -> String {
      let document = XMLDocument(kind: .document)
      document.version = "1.0"
      document.characterEncoding = "utf-8"

      let root = XMLElement(name: "ComicInfo")
      document.setRootElement(root)

      // Add schema attributes
      root.addAttribute(
        XMLNode.attribute(withName: "xmlns:xsi", stringValue: "http://www.w3.org/2001/XMLSchema-instance") as! XMLNode)
      root.addAttribute(
        XMLNode.attribute(withName: "xmlns:xsd", stringValue: "http://www.w3.org/2001/XMLSchema") as! XMLNode)

      // Add all properties in alphabetical order (matching ComicInfo standard)
      if let ageRating = self.ageRating {
        root.addChild(XMLElement(name: "AgeRating", stringValue: ageRating.stringValue))
      }
      if let alternateCount = self.alternateCount {
        root.addChild(XMLElement(name: "AlternateCount", stringValue: String(alternateCount)))
      }
      if let alternateNumber = self.alternateNumber {
        root.addChild(XMLElement(name: "AlternateNumber", stringValue: alternateNumber))
      }
      if let alternateSeries = self.alternateSeries {
        root.addChild(XMLElement(name: "AlternateSeries", stringValue: alternateSeries))
      }
      if let blackAndWhite = self.blackAndWhite {
        root.addChild(XMLElement(name: "BlackAndWhite", stringValue: blackAndWhite.stringValue))
      }
      if let charactersRawData = self.charactersRawData {
        root.addChild(XMLElement(name: "Characters", stringValue: charactersRawData))
      }
      if let colorist = self.colorist {
        root.addChild(XMLElement(name: "Colorist", stringValue: colorist))
      }
      if let communityRating = self.communityRating {
        root.addChild(XMLElement(name: "CommunityRating", stringValue: String(communityRating)))
      }
      if let count = self.count {
        root.addChild(XMLElement(name: "Count", stringValue: String(count)))
      }
      if let coverArtist = self.coverArtist {
        root.addChild(XMLElement(name: "CoverArtist", stringValue: coverArtist))
      }
      if let day = self.day {
        root.addChild(XMLElement(name: "Day", stringValue: String(day)))
      }
      if let editor = self.editor {
        root.addChild(XMLElement(name: "Editor", stringValue: editor))
      }
      if let format = self.format {
        root.addChild(XMLElement(name: "Format", stringValue: format))
      }
      if let genreRawData = self.genreRawData {
        root.addChild(XMLElement(name: "Genre", stringValue: genreRawData))
      }
      if let imprint = self.imprint {
        root.addChild(XMLElement(name: "Imprint", stringValue: imprint))
      }
      if let inker = self.inker {
        root.addChild(XMLElement(name: "Inker", stringValue: inker))
      }
      if let languageISO = self.languageISO {
        root.addChild(XMLElement(name: "LanguageISO", stringValue: languageISO))
      }
      if let letterer = self.letterer {
        root.addChild(XMLElement(name: "Letterer", stringValue: letterer))
      }
      if let locationsRawData = self.locationsRawData {
        root.addChild(XMLElement(name: "Locations", stringValue: locationsRawData))
      }
      if let mainCharacterOrTeam = self.mainCharacterOrTeam {
        root.addChild(XMLElement(name: "MainCharacterOrTeam", stringValue: mainCharacterOrTeam))
      }
      if let manga = self.manga {
        root.addChild(XMLElement(name: "Manga", stringValue: manga.stringValue))
      }
      if let month = self.month {
        root.addChild(XMLElement(name: "Month", stringValue: String(month)))
      }
      if let notes = self.notes {
        root.addChild(XMLElement(name: "Notes", stringValue: notes))
      }
      if let number = self.number {
        root.addChild(XMLElement(name: "Number", stringValue: number))
      }
      if let pageCount = self.pageCount {
        root.addChild(XMLElement(name: "PageCount", stringValue: String(pageCount)))
      }
      if let penciller = self.penciller {
        root.addChild(XMLElement(name: "Penciller", stringValue: penciller))
      }
      if let publisher = self.publisher {
        root.addChild(XMLElement(name: "Publisher", stringValue: publisher))
      }
      if let review = self.review {
        root.addChild(XMLElement(name: "Review", stringValue: review))
      }
      if let scanInformation = self.scanInformation {
        root.addChild(XMLElement(name: "ScanInformation", stringValue: scanInformation))
      }
      if let series = self.series {
        root.addChild(XMLElement(name: "Series", stringValue: series))
      }
      if let seriesGroup = self.seriesGroup {
        root.addChild(XMLElement(name: "SeriesGroup", stringValue: seriesGroup))
      }
      if let storyArc = self.storyArc {
        root.addChild(XMLElement(name: "StoryArc", stringValue: storyArc))
      }
      if let storyArcNumber = self.storyArcNumber {
        root.addChild(XMLElement(name: "StoryArcNumber", stringValue: storyArcNumber))
      }
      if let summary = self.summary {
        root.addChild(XMLElement(name: "Summary", stringValue: summary))
      }
      if let teamsRawData = self.teamsRawData {
        root.addChild(XMLElement(name: "Teams", stringValue: teamsRawData))
      }
      if let title = self.title {
        root.addChild(XMLElement(name: "Title", stringValue: title))
      }
      if let translator = self.translator {
        root.addChild(XMLElement(name: "Translator", stringValue: translator))
      }
      if let volume = self.volume {
        root.addChild(XMLElement(name: "Volume", stringValue: String(volume)))
      }
      if let webRawData = self.webRawData {
        root.addChild(XMLElement(name: "Web", stringValue: webRawData))
      }
      if let writer = self.writer {
        root.addChild(XMLElement(name: "Writer", stringValue: writer))
      }
      if let year = self.year {
        root.addChild(XMLElement(name: "Year", stringValue: String(year)))
      }

      // Add Pages element if there are any pages
      if !pages.isEmpty {
        let pagesElement = XMLElement(name: "Pages")
        for page in pages {
          let pageElement = XMLElement(name: "Page")

          pageElement.addAttribute(XMLNode.attribute(withName: "Image", stringValue: String(page.image)) as! XMLNode)
          pageElement.addAttribute(XMLNode.attribute(withName: "Type", stringValue: page.type.stringValue) as! XMLNode)

          if page.doublePage {
            pageElement.addAttribute(XMLNode.attribute(withName: "DoublePage", stringValue: "true") as! XMLNode)
          }
          if page.imageSize != 0 {
            pageElement.addAttribute(
              XMLNode.attribute(withName: "ImageSize", stringValue: String(page.imageSize)) as! XMLNode)
          }
          if !page.key.isEmpty {
            pageElement.addAttribute(XMLNode.attribute(withName: "Key", stringValue: page.key) as! XMLNode)
          }
          if !page.bookmark.isEmpty {
            pageElement.addAttribute(XMLNode.attribute(withName: "Bookmark", stringValue: page.bookmark) as! XMLNode)
          }
          if page.imageWidth != -1 {
            pageElement.addAttribute(
              XMLNode.attribute(withName: "ImageWidth", stringValue: String(page.imageWidth)) as! XMLNode)
          }
          if page.imageHeight != -1 {
            pageElement.addAttribute(
              XMLNode.attribute(withName: "ImageHeight", stringValue: String(page.imageHeight)) as! XMLNode)
          }

          pagesElement.addChild(pageElement)
        }
        root.addChild(pagesElement)
      }

      let xmlData = document.xmlData(options: [.nodePrettyPrint])
      guard let xmlString = String(data: xmlData, encoding: .utf8) else {
        throw ComicInfoError.parseError("Failed to convert XML data to string")
      }

      return xmlString
    }

    /// Split comma-separated string into array of trimmed strings.
    private func splitCommaSeparated(_ text: String?) -> [String] {
      guard let text = text, !text.isEmpty else {
        return []
      }
      return text.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
    }

    /// Load Issue from an XML string.
    public static func load(fromXML xmlString: String) throws -> Issue {
      guard !xmlString.isEmpty else {
        throw ComicInfoError.parseError("XML string cannot be nil or empty")
      }

      guard let data = xmlString.data(using: .utf8) else {
        throw ComicInfoError.parseError("Could not convert XML to data")
      }

      let document: XMLDocument
      do {
        document = try XMLDocument(data: data, options: [])
      } catch {
        throw ComicInfoError.parseError("Invalid XML syntax: \(error.localizedDescription)")
      }

      guard let root = document.rootElement() else {
        throw ComicInfoError.parseError("No root element found")
      }

      guard root.name == "ComicInfo" else {
        throw ComicInfoError.parseError("No ComicInfo root element found")
      }

      let ageRating = try root.elements(forName: "AgeRating").first?.stringValue.map {
        try AgeRating.validated(from: $0)
      }
      let alternateCount = root.elements(forName: "AlternateCount").first?.stringValue.flatMap { Int($0) }
      let alternateNumber = root.elements(forName: "AlternateNumber").first?.stringValue?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let alternateSeries = root.elements(forName: "AlternateSeries").first?.stringValue?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let blackAndWhite = try root.elements(forName: "BlackAndWhite").first?.stringValue.map {
        try BlackAndWhite.validated(from: $0)
      }
      let charactersRawData = root.elements(forName: "Characters").first?.stringValue?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let colorist = root.elements(forName: "Colorist").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let communityRating = try root.elements(forName: "CommunityRating").first?.stringValue.map {
        try ComicInfo.validateCommunityRating($0)
      }
      let count = root.elements(forName: "Count").first?.stringValue.map {
        $0.trimmingCharacters(in: .whitespacesAndNewlines)
      }.flatMap { trimmed in
        trimmed.isEmpty ? nil : Int(trimmed)
      }
      let coverArtist = root.elements(forName: "CoverArtist").first?.stringValue?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let day = try root.elements(forName: "Day").first?.stringValue.map {
        let result = try ComicInfo.validateDay($0)
        return result == 0 ? nil : result
      }.flatMap { $0 }
      let editor = root.elements(forName: "Editor").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let format = root.elements(forName: "Format").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let genreRawData = root.elements(forName: "Genre").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let imprint = root.elements(forName: "Imprint").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let inker = root.elements(forName: "Inker").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let languageISO = root.elements(forName: "LanguageISO").first?.stringValue?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let letterer = root.elements(forName: "Letterer").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let locationsRawData = root.elements(forName: "Locations").first?.stringValue?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let mainCharacterOrTeam = root.elements(forName: "MainCharacterOrTeam").first?.stringValue?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let manga = try root.elements(forName: "Manga").first?.stringValue.map {
        try Manga.validated(from: $0)
      }
      let month = try root.elements(forName: "Month").first?.stringValue.map {
        let result = try ComicInfo.validateMonth($0)
        return result == 0 ? nil : result
      }.flatMap { $0 }
      let notes = root.elements(forName: "Notes").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let number = root.elements(forName: "Number").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let pageCount = root.elements(forName: "PageCount").first?.stringValue.flatMap { Int($0) }
      let penciller = root.elements(forName: "Penciller").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let publisher = root.elements(forName: "Publisher").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let review = root.elements(forName: "Review").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let scanInformation = root.elements(forName: "ScanInformation").first?.stringValue?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let series = root.elements(forName: "Series").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let seriesGroup = root.elements(forName: "SeriesGroup").first?.stringValue?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let storyArc = root.elements(forName: "StoryArc").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let storyArcNumber = root.elements(forName: "StoryArcNumber").first?.stringValue?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let summary = root.elements(forName: "Summary").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let teamsRawData = root.elements(forName: "Teams").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let title = root.elements(forName: "Title").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let translator = root.elements(forName: "Translator").first?.stringValue?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let volume = root.elements(forName: "Volume").first?.stringValue.map {
        $0.trimmingCharacters(in: .whitespacesAndNewlines)
      }.flatMap { trimmed in
        trimmed.isEmpty ? nil : Int(trimmed)
      }
      let webRawData = root.elements(forName: "Web").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let writer = root.elements(forName: "Writer").first?.stringValue?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let year = try root.elements(forName: "Year").first?.stringValue.map {
        try ComicInfo.validateYear($0)
      }

      // Parse Pages
      let pages = try parsePagesElement(root)

      return Issue(
        ageRating: ageRating,
        alternateCount: alternateCount,
        alternateNumber: alternateNumber,
        alternateSeries: alternateSeries,
        blackAndWhite: blackAndWhite,
        charactersRawData: charactersRawData,
        colorist: colorist,
        communityRating: communityRating,
        count: count,
        coverArtist: coverArtist,
        day: day,
        editor: editor,
        format: format,
        genreRawData: genreRawData,
        imprint: imprint,
        inker: inker,
        languageISO: languageISO,
        letterer: letterer,
        locationsRawData: locationsRawData,
        mainCharacterOrTeam: mainCharacterOrTeam,
        manga: manga,
        month: month,
        notes: notes,
        number: number,
        pageCount: pageCount,
        penciller: penciller,
        publisher: publisher,
        review: review,
        scanInformation: scanInformation,
        series: series,
        seriesGroup: seriesGroup,
        storyArc: storyArc,
        storyArcNumber: storyArcNumber,
        summary: summary,
        teamsRawData: teamsRawData,
        title: title,
        translator: translator,
        volume: volume,
        webRawData: webRawData,
        writer: writer,
        year: year,
        pages: pages)
    }

    /// Parse Pages element from XML root and return array of Page objects.
    private static func parsePagesElement(_ root: XMLElement) throws -> [Page] {
      guard let pagesElement = root.elements(forName: "Pages").first else {
        return []
      }

      let pageElements = pagesElement.elements(forName: "Page")
      var pages: [Page] = []

      for pageElement in pageElements {
        // Required attribute: Image
        guard let imageAttr = pageElement.attribute(forName: "Image")?.stringValue else {
          throw ComicInfoError.schemaError("Page element missing required Image attribute")
        }
        guard let image = Int(imageAttr) else {
          throw ComicInfoError.typeCoercionError(field: "Page.Image", value: imageAttr, expectedType: "Int")
        }

        // Optional attributes with defaults
        let typeValue = pageElement.attribute(forName: "Type")?.stringValue ?? "Story"
        let type = try PageType.validated(from: typeValue)

        let doublePageValue = pageElement.attribute(forName: "DoublePage")?.stringValue ?? "false"
        let doublePage = parseBoolean(doublePageValue, field: "DoublePage")

        let imageSizeValue = pageElement.attribute(forName: "ImageSize")?.stringValue ?? "0"
        let imageSize = Int(imageSizeValue) ?? 0

        let key = pageElement.attribute(forName: "Key")?.stringValue ?? ""
        let bookmark = pageElement.attribute(forName: "Bookmark")?.stringValue ?? ""

        let imageWidthValue = pageElement.attribute(forName: "ImageWidth")?.stringValue ?? "-1"
        let imageWidth = Int(imageWidthValue) ?? -1

        let imageHeightValue = pageElement.attribute(forName: "ImageHeight")?.stringValue ?? "-1"
        let imageHeight = Int(imageHeightValue) ?? -1

        let page = Page(
          image: image,
          type: type,
          doublePage: doublePage,
          imageSize: imageSize,
          key: key,
          bookmark: bookmark,
          imageWidth: imageWidth,
          imageHeight: imageHeight
        )

        pages.append(page)
      }

      return pages
    }

    /// Parse boolean value from string for page attributes.
    private static func parseBoolean(_ value: String, field: String) -> Bool {
      switch value.lowercased() {
      case "true", "1", "yes":
        return true
      case "false", "0", "no", "":
        return false
      default:
        // Non-throwing, return false for invalid values
        return false
      }
    }
  }
}
