//
// Issue.swift
// ComicInfo
//

import AEXML
import Foundation
import Yams

extension AEXMLElement {
  /// Text of the first child element with this name: nil when there is no such child, and an empty
  /// string when the child is present but empty.
  fileprivate func text(ofChild name: String) -> String? {
    children.first { $0.name == name }.map { $0.value ?? "" }
  }
}

/// String extension for handling empty values in ComicInfo parsing
extension String {
  /// Returns nil if the string is empty, otherwise returns self.
  ///
  /// Used internally to convert empty XML text content to nil values.
  fileprivate var nilIfEmpty: String? {
    return self.isEmpty ? nil : self
  }
}

extension ComicInfo {
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

    /// Decodes an issue, reading `communityRating` as a string and validating it back into a `Double`.
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)

      ageRating = try container.decodeIfPresent(AgeRating.self, forKey: .ageRating)
      alternateCount = try container.decodeIfPresent(Int.self, forKey: .alternateCount)
      alternateNumber = try container.decodeIfPresent(String.self, forKey: .alternateNumber)
      alternateSeries = try container.decodeIfPresent(String.self, forKey: .alternateSeries)
      blackAndWhite = try container.decodeIfPresent(BlackAndWhite.self, forKey: .blackAndWhite)
      charactersRawData = try container.decodeIfPresent(String.self, forKey: .charactersRawData)
      colorist = try container.decodeIfPresent(String.self, forKey: .colorist)

      if let ratingString = try container.decodeIfPresent(String.self, forKey: .communityRating) {
        communityRating = try NumericField.communityRating.double(from: ratingString)
      } else {
        communityRating = nil
      }

      count = try container.decodeIfPresent(Int.self, forKey: .count)
      coverArtist = try container.decodeIfPresent(String.self, forKey: .coverArtist)
      day = try container.decodeIfPresent(Int.self, forKey: .day)
      editor = try container.decodeIfPresent(String.self, forKey: .editor)
      format = try container.decodeIfPresent(String.self, forKey: .format)
      genreRawData = try container.decodeIfPresent(String.self, forKey: .genreRawData)
      imprint = try container.decodeIfPresent(String.self, forKey: .imprint)
      inker = try container.decodeIfPresent(String.self, forKey: .inker)
      languageISO = try container.decodeIfPresent(String.self, forKey: .languageISO)
      letterer = try container.decodeIfPresent(String.self, forKey: .letterer)
      locationsRawData = try container.decodeIfPresent(String.self, forKey: .locationsRawData)
      mainCharacterOrTeam = try container.decodeIfPresent(String.self, forKey: .mainCharacterOrTeam)
      manga = try container.decodeIfPresent(Manga.self, forKey: .manga)
      month = try container.decodeIfPresent(Int.self, forKey: .month)
      notes = try container.decodeIfPresent(String.self, forKey: .notes)
      number = try container.decodeIfPresent(String.self, forKey: .number)
      pageCount = try container.decodeIfPresent(Int.self, forKey: .pageCount)
      penciller = try container.decodeIfPresent(String.self, forKey: .penciller)
      publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
      review = try container.decodeIfPresent(String.self, forKey: .review)
      scanInformation = try container.decodeIfPresent(String.self, forKey: .scanInformation)
      series = try container.decodeIfPresent(String.self, forKey: .series)
      seriesGroup = try container.decodeIfPresent(String.self, forKey: .seriesGroup)
      storyArc = try container.decodeIfPresent(String.self, forKey: .storyArc)
      storyArcNumber = try container.decodeIfPresent(String.self, forKey: .storyArcNumber)
      summary = try container.decodeIfPresent(String.self, forKey: .summary)
      teamsRawData = try container.decodeIfPresent(String.self, forKey: .teamsRawData)
      title = try container.decodeIfPresent(String.self, forKey: .title)
      translator = try container.decodeIfPresent(String.self, forKey: .translator)
      volume = try container.decodeIfPresent(Int.self, forKey: .volume)
      webRawData = try container.decodeIfPresent(String.self, forKey: .webRawData)
      writer = try container.decodeIfPresent(String.self, forKey: .writer)
      year = try container.decodeIfPresent(Int.self, forKey: .year)
      pages = try container.decode([Page].self, forKey: .pages)
    }

    /// Encodes the issue, writing `communityRating` as a string so JSON and YAML avoid `Double` formatting artifacts.
    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)

      try container.encodeIfPresent(ageRating, forKey: .ageRating)
      try container.encodeIfPresent(alternateCount, forKey: .alternateCount)
      try container.encodeIfPresent(alternateNumber, forKey: .alternateNumber)
      try container.encodeIfPresent(alternateSeries, forKey: .alternateSeries)
      try container.encodeIfPresent(blackAndWhite, forKey: .blackAndWhite)
      try container.encodeIfPresent(charactersRawData, forKey: .charactersRawData)
      try container.encodeIfPresent(colorist, forKey: .colorist)
      try container.encodeIfPresent(communityRating.map { String($0) }, forKey: .communityRating)
      try container.encodeIfPresent(count, forKey: .count)
      try container.encodeIfPresent(coverArtist, forKey: .coverArtist)
      try container.encodeIfPresent(day, forKey: .day)
      try container.encodeIfPresent(editor, forKey: .editor)
      try container.encodeIfPresent(format, forKey: .format)
      try container.encodeIfPresent(genreRawData, forKey: .genreRawData)
      try container.encodeIfPresent(imprint, forKey: .imprint)
      try container.encodeIfPresent(inker, forKey: .inker)
      try container.encodeIfPresent(languageISO, forKey: .languageISO)
      try container.encodeIfPresent(letterer, forKey: .letterer)
      try container.encodeIfPresent(locationsRawData, forKey: .locationsRawData)
      try container.encodeIfPresent(mainCharacterOrTeam, forKey: .mainCharacterOrTeam)
      try container.encodeIfPresent(manga, forKey: .manga)
      try container.encodeIfPresent(month, forKey: .month)
      try container.encodeIfPresent(notes, forKey: .notes)
      try container.encodeIfPresent(number, forKey: .number)
      try container.encodeIfPresent(pageCount, forKey: .pageCount)
      try container.encodeIfPresent(penciller, forKey: .penciller)
      try container.encodeIfPresent(publisher, forKey: .publisher)
      try container.encodeIfPresent(review, forKey: .review)
      try container.encodeIfPresent(scanInformation, forKey: .scanInformation)
      try container.encodeIfPresent(series, forKey: .series)
      try container.encodeIfPresent(seriesGroup, forKey: .seriesGroup)
      try container.encodeIfPresent(storyArc, forKey: .storyArc)
      try container.encodeIfPresent(storyArcNumber, forKey: .storyArcNumber)
      try container.encodeIfPresent(summary, forKey: .summary)
      try container.encodeIfPresent(teamsRawData, forKey: .teamsRawData)
      try container.encodeIfPresent(title, forKey: .title)
      try container.encodeIfPresent(translator, forKey: .translator)
      try container.encodeIfPresent(volume, forKey: .volume)
      try container.encodeIfPresent(webRawData, forKey: .webRawData)
      try container.encodeIfPresent(writer, forKey: .writer)
      try container.encodeIfPresent(year, forKey: .year)
      try container.encode(pages, forKey: .pages)
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

    /// Checks that every numeric value is one that loading would accept.
    ///
    /// An `Issue` built with the initializer can hold values that a ComicInfo.xml may not, such as
    /// `year: 86`. `toXMLString()` and `save(to:)` call this, so they never write a file that
    /// cannot be loaded back.
    ///
    /// - Throws: `ComicInfoError.rangeError` for the first value outside its field's range.
    public func validate() throws {
      try NumericField.communityRating.validate(communityRating)
      try NumericField.day.validate(day)
      try NumericField.month.validate(month)
      try NumericField.year.validate(year)
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

    /// Export to YAML String.
    /// - Returns: YAML String representation of the Issue
    /// - Throws: EncodingError if the Issue cannot be encoded
    public func toYAMLString() throws -> String {
      let encoder = YAMLEncoder()
      return try encoder.encode(self)
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
    /// - Throws: ComicInfoError.parseError if XML generation fails, or
    ///   ComicInfoError.rangeError if a value could not be loaded back (see `validate()`)
    public func toXMLString() throws -> String {
      try validate()

      let document = AEXMLDocument()

      // Add schema attributes
      let schemaAttributes = [
        "xmlns:xsd": "http://www.w3.org/2001/XMLSchema",
        "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
      ]
      let root = document.addChild(name: "ComicInfo", attributes: schemaAttributes)

      // Add all properties in alphabetical order (matching ComicInfo standard)
      if let ageRating = self.ageRating {
        root.addChild(name: "AgeRating", value: ageRating.stringValue)
      }
      if let alternateCount = self.alternateCount {
        root.addChild(name: "AlternateCount", value: String(alternateCount))
      }
      if let alternateNumber = self.alternateNumber {
        root.addChild(name: "AlternateNumber", value: alternateNumber)
      }
      if let alternateSeries = self.alternateSeries {
        root.addChild(name: "AlternateSeries", value: alternateSeries)
      }
      if let blackAndWhite = self.blackAndWhite {
        root.addChild(name: "BlackAndWhite", value: blackAndWhite.stringValue)
      }
      if let charactersRawData = self.charactersRawData {
        root.addChild(name: "Characters", value: charactersRawData)
      }
      if let colorist = self.colorist {
        root.addChild(name: "Colorist", value: colorist)
      }
      if let communityRating = self.communityRating {
        root.addChild(name: "CommunityRating", value: String(communityRating))
      }
      if let count = self.count {
        root.addChild(name: "Count", value: String(count))
      }
      if let coverArtist = self.coverArtist {
        root.addChild(name: "CoverArtist", value: coverArtist)
      }
      if let day = self.day {
        root.addChild(name: "Day", value: String(day))
      }
      if let editor = self.editor {
        root.addChild(name: "Editor", value: editor)
      }
      if let format = self.format {
        root.addChild(name: "Format", value: format)
      }
      if let genreRawData = self.genreRawData {
        root.addChild(name: "Genre", value: genreRawData)
      }
      if let imprint = self.imprint {
        root.addChild(name: "Imprint", value: imprint)
      }
      if let inker = self.inker {
        root.addChild(name: "Inker", value: inker)
      }
      if let languageISO = self.languageISO {
        root.addChild(name: "LanguageISO", value: languageISO)
      }
      if let letterer = self.letterer {
        root.addChild(name: "Letterer", value: letterer)
      }
      if let locationsRawData = self.locationsRawData {
        root.addChild(name: "Locations", value: locationsRawData)
      }
      if let mainCharacterOrTeam = self.mainCharacterOrTeam {
        root.addChild(name: "MainCharacterOrTeam", value: mainCharacterOrTeam)
      }
      if let manga = self.manga {
        root.addChild(name: "Manga", value: manga.stringValue)
      }
      if let month = self.month {
        root.addChild(name: "Month", value: String(month))
      }
      if let notes = self.notes {
        root.addChild(name: "Notes", value: notes)
      }
      if let number = self.number {
        root.addChild(name: "Number", value: number)
      }
      if let pageCount = self.pageCount {
        root.addChild(name: "PageCount", value: String(pageCount))
      }
      if let penciller = self.penciller {
        root.addChild(name: "Penciller", value: penciller)
      }
      if let publisher = self.publisher {
        root.addChild(name: "Publisher", value: publisher)
      }
      if let review = self.review {
        root.addChild(name: "Review", value: review)
      }
      if let scanInformation = self.scanInformation {
        root.addChild(name: "ScanInformation", value: scanInformation)
      }
      if let series = self.series {
        root.addChild(name: "Series", value: series)
      }
      if let seriesGroup = self.seriesGroup {
        root.addChild(name: "SeriesGroup", value: seriesGroup)
      }
      if let storyArc = self.storyArc {
        root.addChild(name: "StoryArc", value: storyArc)
      }
      if let storyArcNumber = self.storyArcNumber {
        root.addChild(name: "StoryArcNumber", value: storyArcNumber)
      }
      if let summary = self.summary {
        root.addChild(name: "Summary", value: summary)
      }
      if let teamsRawData = self.teamsRawData {
        root.addChild(name: "Teams", value: teamsRawData)
      }
      if let title = self.title {
        root.addChild(name: "Title", value: title)
      }
      if let translator = self.translator {
        root.addChild(name: "Translator", value: translator)
      }
      if let volume = self.volume {
        root.addChild(name: "Volume", value: String(volume))
      }
      if let webRawData = self.webRawData {
        root.addChild(name: "Web", value: webRawData)
      }
      if let writer = self.writer {
        root.addChild(name: "Writer", value: writer)
      }
      if let year = self.year {
        root.addChild(name: "Year", value: String(year))
      }

      // Add Pages element if there are any pages
      if !pages.isEmpty {
        let pagesElement = root.addChild(name: "Pages")
        for page in pages {
          let pageElement = pagesElement.addChild(name: "Page")

          pageElement.attributes["Image"] = String(page.image)
          let typesValue = page.types.map(\.stringValue).joined(separator: " ")
          pageElement.attributes["Type"] = typesValue

          if page.doublePage {
            pageElement.attributes["DoublePage"] = "true"
          }
          if page.imageSize != 0 {
            pageElement.attributes["ImageSize"] = String(page.imageSize)
          }
          if !page.key.isEmpty {
            pageElement.attributes["Key"] = page.key
          }
          if !page.bookmark.isEmpty {
            pageElement.attributes["Bookmark"] = page.bookmark
          }
          if page.imageWidth != -1 {
            pageElement.attributes["ImageWidth"] = String(page.imageWidth)
          }
          if page.imageHeight != -1 {
            pageElement.attributes["ImageHeight"] = String(page.imageHeight)
          }
        }
      }

      return document.xmlSpaces
    }

    /// Write the ComicInfo XML to a file URL, creating intermediate directories as needed.
    ///
    /// ```swift
    /// try issue.save(to: URL(fileURLWithPath: "/path/to/ComicInfo.xml"))
    /// ```
    ///
    /// - Parameter url: Destination file URL.
    /// - Throws: `ComicInfoError.fileError` if the directory cannot be created or the write fails.
    public func save(to url: URL) throws {
      let xml = try toXMLString()
      do {
        let directory = url.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try xml.write(to: url, atomically: true, encoding: .utf8)
      } catch let error as ComicInfoError {
        throw error
      } catch {
        throw ComicInfoError.fileError("Failed to write to '\(url.path)': \(error.localizedDescription)")
      }
    }

    /// Write the ComicInfo XML to a file path, creating intermediate directories as needed.
    ///
    /// - Parameter path: Destination file path.
    /// - Throws: `ComicInfoError.fileError` if the directory cannot be created or the write fails.
    public func save(to path: String) throws {
      try save(to: URL(fileURLWithPath: path))
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

      // Never resolve external entities: prevents XXE local-file disclosure / SSRF.
      // Keep whitespace as written; each field decides below whether to trim.
      var options = AEXMLOptions()
      options.parserSettings.shouldResolveExternalEntities = false
      options.parserSettings.shouldTrimWhitespace = false

      let document: AEXMLDocument
      do {
        document = try AEXMLDocument(xml: data, options: options)
      } catch {
        throw ComicInfoError.parseError("Invalid XML syntax: \(error.localizedDescription)")
      }

      let root = document.root
      guard root.error == nil else {
        throw ComicInfoError.parseError("No root element found")
      }

      guard root.name == "ComicInfo" else {
        throw ComicInfoError.parseError("No ComicInfo root element found")
      }

      let ageRating = try root.text(ofChild: "AgeRating").map {
        try AgeRating.validated(from: $0)
      }
      let alternateCount = root.text(ofChild: "AlternateCount").flatMap { Int($0) }
      let alternateNumber = root.text(ofChild: "AlternateNumber")?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let alternateSeries = root.text(ofChild: "AlternateSeries")?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let blackAndWhite = try root.text(ofChild: "BlackAndWhite").map {
        try BlackAndWhite.validated(from: $0)
      }
      let charactersRawData = root.text(ofChild: "Characters")?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let colorist = root.text(ofChild: "Colorist")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let communityRating = try root.text(ofChild: "CommunityRating").flatMap {
        try NumericField.communityRating.double(from: $0)
      }
      let count = root.text(ofChild: "Count").map {
        $0.trimmingCharacters(in: .whitespacesAndNewlines)
      }.flatMap { trimmed in
        trimmed.isEmpty ? nil : Int(trimmed)
      }
      let coverArtist = root.text(ofChild: "CoverArtist")?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let day = try root.text(ofChild: "Day").flatMap {
        try NumericField.day.int(from: $0)
      }
      let editor = root.text(ofChild: "Editor")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let format = root.text(ofChild: "Format")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let genreRawData = root.text(ofChild: "Genre")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let imprint = root.text(ofChild: "Imprint")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let inker = root.text(ofChild: "Inker")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let languageISO = root.text(ofChild: "LanguageISO")?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let letterer = root.text(ofChild: "Letterer")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let locationsRawData = root.text(ofChild: "Locations")?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let mainCharacterOrTeam = root.text(ofChild: "MainCharacterOrTeam")?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let manga = try root.text(ofChild: "Manga").map {
        try Manga.validated(from: $0)
      }
      let month = try root.text(ofChild: "Month").flatMap {
        try NumericField.month.int(from: $0)
      }
      let notes = root.text(ofChild: "Notes")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let number = root.text(ofChild: "Number")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let pageCount = root.text(ofChild: "PageCount").flatMap { Int($0) }
      let penciller = root.text(ofChild: "Penciller")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let publisher = root.text(ofChild: "Publisher")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let review = root.text(ofChild: "Review")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let scanInformation = root.text(ofChild: "ScanInformation")?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let series = root.text(ofChild: "Series")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let seriesGroup = root.text(ofChild: "SeriesGroup")?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let storyArc = root.text(ofChild: "StoryArc")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let storyArcNumber = root.text(ofChild: "StoryArcNumber")?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let summary = root.text(ofChild: "Summary")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let teamsRawData = root.text(ofChild: "Teams")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let title = root.text(ofChild: "Title")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let translator = root.text(ofChild: "Translator")?.trimmingCharacters(
        in: .whitespacesAndNewlines
      ).nilIfEmpty
      let volume = root.text(ofChild: "Volume").map {
        $0.trimmingCharacters(in: .whitespacesAndNewlines)
      }.flatMap { trimmed in
        trimmed.isEmpty ? nil : Int(trimmed)
      }
      let webRawData = root.text(ofChild: "Web")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let writer = root.text(ofChild: "Writer")?.trimmingCharacters(in: .whitespacesAndNewlines)
        .nilIfEmpty
      let year = try root.text(ofChild: "Year").flatMap {
        try NumericField.year.int(from: $0)
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
    private static func parsePagesElement(_ root: AEXMLElement) throws -> [Page] {
      guard let pagesElement = root.children.first(where: { $0.name == "Pages" }) else {
        return []
      }

      let pageElements = pagesElement.children.filter { $0.name == "Page" }
      var pages: [Page] = []

      for pageElement in pageElements {
        // Required attribute: Image
        guard let imageAttr = pageElement.attributes["Image"] else {
          throw ComicInfoError.schemaError("Page element missing required Image attribute")
        }
        guard let image = Int(imageAttr) else {
          throw ComicInfoError.typeCoercionError(field: "Page.Image", value: imageAttr, expectedType: "Int")
        }

        // Type is a space-separated list of values (XSD ComicPageType is xs:list).
        let typeValue = pageElement.attributes["Type"] ?? "Story"
        let typeTokens = typeValue.split(whereSeparator: \.isWhitespace).map(String.init)
        let types = try (typeTokens.isEmpty ? ["Story"] : typeTokens).map {
          try PageType.validated(from: $0)
        }

        let doublePageValue = pageElement.attributes["DoublePage"] ?? "false"
        let doublePage = parseBoolean(doublePageValue, field: "DoublePage")

        let imageSizeValue = pageElement.attributes["ImageSize"] ?? "0"
        let imageSize = Int(imageSizeValue) ?? 0

        let key = pageElement.attributes["Key"] ?? ""
        let bookmark = pageElement.attributes["Bookmark"] ?? ""

        let imageWidthValue = pageElement.attributes["ImageWidth"] ?? "-1"
        let imageWidth = Int(imageWidthValue) ?? -1

        let imageHeightValue = pageElement.attributes["ImageHeight"] ?? "-1"
        let imageHeight = Int(imageHeightValue) ?? -1

        let page = Page(
          image: image,
          types: types,
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
