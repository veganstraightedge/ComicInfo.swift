//
// ComicInfo.swift
// ComicInfo
//

import Foundation

/// Errors that can occur during ComicInfo parsing and processing
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

/// Main entry point for loading ComicInfo data
public enum ComicInfo {

  /// Load ComicInfo from an XML string
  public static func load(fromXML xmlString: String) throws -> Issue {
    return try Issue.load(fromXML: xmlString)
  }

  /// Represents a comic book issue with metadata from ComicInfo.xml
  public struct Issue {
    public let ageRating: String?
    public let alternateCount: Int?
    public let alternateNumber: String?
    public let alternateSeries: String?
    public let blackAndWhite: String?
    public let characters: String?
    public let colorist: String?
    public let communityRating: Double?
    public let count: Int?
    public let coverArtist: String?
    public let day: Int?
    public let editor: String?
    public let format: String?
    public let genre: String?
    public let imprint: String?
    public let inker: String?
    public let languageISO: String?
    public let letterer: String?
    public let locations: String?
    public let mainCharacterOrTeam: String?
    public let manga: String?
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
    public let teams: String?
    public let title: String?
    public let translator: String?
    public let volume: Int?
    public let web: String?
    public let writer: String?
    public let year: Int?

    public init(
      ageRating: String? = nil,
      alternateCount: Int? = nil,
      alternateNumber: String? = nil,
      alternateSeries: String? = nil,
      blackAndWhite: String? = nil,
      characters: String? = nil,
      colorist: String? = nil,
      communityRating: Double? = nil,
      count: Int? = nil,
      coverArtist: String? = nil,
      day: Int? = nil,
      editor: String? = nil,
      format: String? = nil,
      genre: String? = nil,
      imprint: String? = nil,
      inker: String? = nil,
      languageISO: String? = nil,
      letterer: String? = nil,
      locations: String? = nil,
      mainCharacterOrTeam: String? = nil,
      manga: String? = nil,
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
      teams: String? = nil,
      title: String? = nil,
      translator: String? = nil,
      volume: Int? = nil,
      web: String? = nil,
      writer: String? = nil,
      year: Int? = nil
    ) {
      self.ageRating = ageRating
      self.alternateCount = alternateCount
      self.alternateNumber = alternateNumber
      self.alternateSeries = alternateSeries
      self.blackAndWhite = blackAndWhite
      self.characters = characters
      self.colorist = colorist
      self.communityRating = communityRating
      self.count = count
      self.coverArtist = coverArtist
      self.day = day
      self.editor = editor
      self.format = format
      self.genre = genre
      self.imprint = imprint
      self.inker = inker
      self.languageISO = languageISO
      self.letterer = letterer
      self.locations = locations
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
      self.teams = teams
      self.title = title
      self.translator = translator
      self.volume = volume
      self.web = web
      self.writer = writer
      self.year = year
    }

    /// Load Issue from an XML string
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

      let ageRating = root.elements(forName: "AgeRating").first?.stringValue
      let alternateCount = root.elements(forName: "AlternateCount").first?.stringValue.flatMap { Int($0) }
      let alternateNumber = root.elements(forName: "AlternateNumber").first?.stringValue
      let alternateSeries = root.elements(forName: "AlternateSeries").first?.stringValue
      let blackAndWhite = root.elements(forName: "BlackAndWhite").first?.stringValue
      let characters = root.elements(forName: "Characters").first?.stringValue
      let colorist = root.elements(forName: "Colorist").first?.stringValue
      let communityRating = root.elements(forName: "CommunityRating").first?.stringValue.flatMap { Double($0) }
      let count = root.elements(forName: "Count").first?.stringValue.flatMap { Int($0) }
      let coverArtist = root.elements(forName: "CoverArtist").first?.stringValue
      let day = root.elements(forName: "Day").first?.stringValue.flatMap { Int($0) }
      let editor = root.elements(forName: "Editor").first?.stringValue
      let format = root.elements(forName: "Format").first?.stringValue
      let genre = root.elements(forName: "Genre").first?.stringValue
      let imprint = root.elements(forName: "Imprint").first?.stringValue
      let inker = root.elements(forName: "Inker").first?.stringValue
      let languageISO = root.elements(forName: "LanguageISO").first?.stringValue
      let letterer = root.elements(forName: "Letterer").first?.stringValue
      let locations = root.elements(forName: "Locations").first?.stringValue
      let mainCharacterOrTeam = root.elements(forName: "MainCharacterOrTeam").first?.stringValue
      let manga = root.elements(forName: "Manga").first?.stringValue
      let month = root.elements(forName: "Month").first?.stringValue.flatMap { Int($0) }
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
      let teams = root.elements(forName: "Teams").first?.stringValue
      let title = root.elements(forName: "Title").first?.stringValue
      let translator = root.elements(forName: "Translator").first?.stringValue
      let volume = root.elements(forName: "Volume").first?.stringValue.flatMap { Int($0) }
      let web = root.elements(forName: "Web").first?.stringValue
      let writer = root.elements(forName: "Writer").first?.stringValue
      let year = root.elements(forName: "Year").first?.stringValue.flatMap { Int($0) }

      return Issue(
        ageRating: ageRating,
        alternateCount: alternateCount,
        alternateNumber: alternateNumber,
        alternateSeries: alternateSeries,
        blackAndWhite: blackAndWhite,
        characters: characters,
        colorist: colorist,
        communityRating: communityRating,
        count: count,
        coverArtist: coverArtist,
        day: day,
        editor: editor,
        format: format,
        genre: genre,
        imprint: imprint,
        inker: inker,
        languageISO: languageISO,
        letterer: letterer,
        locations: locations,
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
        teams: teams,
        title: title,
        translator: translator,
        volume: volume,
        web: web,
        writer: writer,
        year: year)
    }
  }
}
