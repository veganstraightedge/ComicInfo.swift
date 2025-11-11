//
// ComicInfo.swift
// ComicInfo
//

import Foundation

/// Errors that can occur during ComicInfo parsing and processing.
public enum ComicInfoError: Error, Equatable {
  case parseError(String)
  case fileError(String)
  case invalidEnum(field: String, value: String, validValues: [String])
  case rangeError(field: String, value: String, min: String, max: String)
  case typeCoercionError(field: String, value: String, expectedType: String)
  case schemaError(String)
}

extension ComicInfoError: LocalizedError {
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
    guard let month = Int(value) else {
      throw ComicInfoError.typeCoercionError(field: "Month", value: value, expectedType: "Int")
    }
    if !(1...12).contains(month) {
      throw ComicInfoError.rangeError(field: "Month", value: value, min: "1", max: "12")
    }
    return month
  }

  fileprivate static func validateDay(_ value: String) throws -> Int {
    guard let day = Int(value) else {
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

  /// Manga enum representing manga reading direction.
  public enum Manga: String, CaseIterable, Equatable {
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

  /// Age rating enum.
  public enum AgeRating: String, CaseIterable, Equatable {
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

  /// Black and white enum.
  public enum BlackAndWhite: String, CaseIterable, Equatable {
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
  public enum PageType: String, CaseIterable, Equatable {
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
  public struct Page: Equatable, Hashable {
    public let image: Int
    public let type: PageType
    public let doublePage: Bool
    public let imageSize: Int
    public let key: String
    public let bookmark: String
    public let imageWidth: Int
    public let imageHeight: Int

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
  public static func load(fromXML xmlString: String) throws -> Issue {
    return try Issue.load(fromXML: xmlString)
  }

  /// Load ComicInfo from a file path or XML string (smart detection).
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
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
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
  public struct Issue {
    public let ageRating: AgeRating?
    public let alternateCount: Int?
    public let alternateNumber: String?
    public let alternateSeries: String?
    public let blackAndWhite: BlackAndWhite?
    public let charactersRawData: String?
    public let colorist: String?
    public let communityRating: Double?
    public let count: Int?
    public let coverArtist: String?
    public let day: Int?
    public let editor: String?
    public let format: String?
    public let genreRawData: String?
    public let imprint: String?
    public let inker: String?
    public let languageISO: String?
    public let letterer: String?
    public let locationsRawData: String?
    public let mainCharacterOrTeam: String?
    public let manga: Manga?
    public let month: Int?
    public let notes: String?
    public let number: String?
    public let pageCount: Int?
    public let penciller: String?
    public let publisher: String?
    public let review: String?
    public let scanInformation: String?
    public let series: String?
    public let seriesGroup: String?
    public let storyArc: String?
    public let storyArcNumber: String?
    public let summary: String?
    public let teamsRawData: String?
    public let title: String?
    public let translator: String?
    public let volume: Int?
    public let webRawData: String?
    public let writer: String?
    public let year: Int?
    public let pages: [Page]

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
    public var characters: [String] {
      return splitCommaSeparated(charactersRawData)
    }

    /// Array of teams split from comma-separated string.
    public var teams: [String] {
      return splitCommaSeparated(teamsRawData)
    }

    /// Array of locations split from comma-separated string.
    public var locations: [String] {
      return splitCommaSeparated(locationsRawData)
    }

    /// Array of genres split from comma-separated string.
    public var genres: [String] {
      return splitCommaSeparated(genreRawData)
    }

    /// Array of web URLs split from whitespace-separated string.
    public var webUrls: [URL] {
      guard let web = webRawData, !web.isEmpty else {
        return []
      }
      return web.split(separator: " ").compactMap { URL(string: String($0)) }
    }

    /// True if this issue has pages.
    public var hasPages: Bool {
      return !pages.isEmpty
    }

    /// Get only cover pages from the pages array.
    public var coverPages: [Page] {
      return pages.filter { $0.isCover }
    }

    /// Get only story pages from the pages array.
    public var storyPages: [Page] {
      return pages.filter { $0.isStory }
    }

    /// True if this issue is a manga (Yes or YesAndRightToLeft).
    public var isManga: Bool {
      return manga?.isManga == true
    }

    /// True if this issue uses right-to-left reading direction.
    public var isRightToLeft: Bool {
      return manga?.isRightToLeft == true
    }

    /// True if this issue is black and white.
    public var isBlackAndWhite: Bool {
      return blackAndWhite?.isBlackAndWhite == true
    }

    /// Get publication date as Date object if available.
    /// Uses year, month, day fields with defaults for missing components.
    public var publicationDate: Date? {
      guard let year = year, year > 0 else {
        return nil
      }

      let month = self.month ?? 1
      let day = self.day ?? 1

      let components = DateComponents(year: year, month: month, day: day)
      return Calendar.current.date(from: components)
    }

    /// Split comma-separated string into array of trimmed strings.
    private func splitCommaSeparated(_ text: String?) -> [String] {
      guard let text = text, !text.isEmpty else {
        return []
      }
      return text.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
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
      let alternateNumber = root.elements(forName: "AlternateNumber").first?.stringValue
      let alternateSeries = root.elements(forName: "AlternateSeries").first?.stringValue
      let blackAndWhite = try root.elements(forName: "BlackAndWhite").first?.stringValue.map {
        try BlackAndWhite.validated(from: $0)
      }
      let charactersRawData = root.elements(forName: "Characters").first?.stringValue
      let colorist = root.elements(forName: "Colorist").first?.stringValue
      let communityRating = try root.elements(forName: "CommunityRating").first?.stringValue.map {
        try ComicInfo.validateCommunityRating($0)
      }
      let count = root.elements(forName: "Count").first?.stringValue.flatMap { Int($0) }
      let coverArtist = root.elements(forName: "CoverArtist").first?.stringValue
      let day = try root.elements(forName: "Day").first?.stringValue.map {
        try ComicInfo.validateDay($0)
      }
      let editor = root.elements(forName: "Editor").first?.stringValue
      let format = root.elements(forName: "Format").first?.stringValue
      let genreRawData = root.elements(forName: "Genre").first?.stringValue
      let imprint = root.elements(forName: "Imprint").first?.stringValue
      let inker = root.elements(forName: "Inker").first?.stringValue
      let languageISO = root.elements(forName: "LanguageISO").first?.stringValue
      let letterer = root.elements(forName: "Letterer").first?.stringValue
      let locationsRawData = root.elements(forName: "Locations").first?.stringValue
      let mainCharacterOrTeam = root.elements(forName: "MainCharacterOrTeam").first?.stringValue
      let manga = try root.elements(forName: "Manga").first?.stringValue.map {
        try Manga.validated(from: $0)
      }
      let month = try root.elements(forName: "Month").first?.stringValue.map {
        try ComicInfo.validateMonth($0)
      }
      let notes = root.elements(forName: "Notes").first?.stringValue
      let number = root.elements(forName: "Number").first?.stringValue
      let pageCount = root.elements(forName: "PageCount").first?.stringValue.flatMap { Int($0) }
      let penciller = root.elements(forName: "Penciller").first?.stringValue
      let publisher = root.elements(forName: "Publisher").first?.stringValue
      let review = root.elements(forName: "Review").first?.stringValue
      let scanInformation = root.elements(forName: "ScanInformation").first?.stringValue
      let series = root.elements(forName: "Series").first?.stringValue
      let seriesGroup = root.elements(forName: "SeriesGroup").first?.stringValue
      let storyArc = root.elements(forName: "StoryArc").first?.stringValue
      let storyArcNumber = root.elements(forName: "StoryArcNumber").first?.stringValue
      let summary = root.elements(forName: "Summary").first?.stringValue
      let teamsRawData = root.elements(forName: "Teams").first?.stringValue
      let title = root.elements(forName: "Title").first?.stringValue
      let translator = root.elements(forName: "Translator").first?.stringValue
      let volume = root.elements(forName: "Volume").first?.stringValue.flatMap { Int($0) }
      let webRawData = root.elements(forName: "Web").first?.stringValue
      let writer = root.elements(forName: "Writer").first?.stringValue
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
