//
// ComicInfo.swift
// ComicInfo
//

import Foundation

/// Main entry point for loading ComicInfo data
public enum ComicInfo {

  /// Load ComicInfo from an XML string
  public static func load(fromXML xmlString: String) throws -> Issue {
    return try Issue.load(fromXML: xmlString)
  }

  /// Represents a comic book issue with metadata from ComicInfo.xml
  public struct Issue {
    public let title: String?
    public let series: String?
    public let number: String?
    public let count: Int?
    public let volume: Int?
    public let summary: String?
    public let notes: String?
    public let writer: String?
    public let penciller: String?
    public let inker: String?
    public let colorist: String?
    public let letterer: String?
    public let coverArtist: String?
    public let editor: String?
    public let translator: String?
    public let publisher: String?
    public let imprint: String?
    public let format: String?
    public let languageISO: String?
    public let alternateSeries: String?
    public let alternateNumber: String?
    public let genre: String?
    public let web: String?
    public let characters: String?
    public let teams: String?
    public let locations: String?
    public let scanInformation: String?
    public let storyArc: String?
    public let storyArcNumber: String?
    public let seriesGroup: String?
    public let mainCharacterOrTeam: String?
    public let review: String?
    public let communityRating: Double?
    public let blackAndWhite: String?
    public let manga: String?
    public let ageRating: String?
    public let year: Int?
    public let month: Int?
    public let day: Int?
    public let alternateCount: Int?
    public let pageCount: Int?

    public init(
      title: String? = nil,
      series: String? = nil,
      number: String? = nil,
      count: Int? = nil,
      volume: Int? = nil,
      summary: String? = nil,
      notes: String? = nil,
      writer: String? = nil,
      penciller: String? = nil,
      inker: String? = nil,
      colorist: String? = nil,
      letterer: String? = nil,
      coverArtist: String? = nil,
      editor: String? = nil,
      translator: String? = nil,
      publisher: String? = nil,
      imprint: String? = nil,
      format: String? = nil,
      languageISO: String? = nil,
      alternateSeries: String? = nil,
      alternateNumber: String? = nil,
      genre: String? = nil,
      web: String? = nil,
      characters: String? = nil,
      teams: String? = nil,
      locations: String? = nil,
      scanInformation: String? = nil,
      storyArc: String? = nil,
      storyArcNumber: String? = nil,
      seriesGroup: String? = nil,
      mainCharacterOrTeam: String? = nil,
      review: String? = nil,
      communityRating: Double? = nil,
      blackAndWhite: String? = nil,
      manga: String? = nil,
      ageRating: String? = nil,
      year: Int? = nil,
      month: Int? = nil,
      day: Int? = nil,
      alternateCount: Int? = nil,
      pageCount: Int? = nil
    ) {
      self.title = title
      self.series = series
      self.number = number
      self.count = count
      self.volume = volume
      self.summary = summary
      self.notes = notes
      self.writer = writer
      self.penciller = penciller
      self.inker = inker
      self.colorist = colorist
      self.letterer = letterer
      self.coverArtist = coverArtist
      self.editor = editor
      self.translator = translator
      self.publisher = publisher
      self.imprint = imprint
      self.format = format
      self.languageISO = languageISO
      self.alternateSeries = alternateSeries
      self.alternateNumber = alternateNumber
      self.genre = genre
      self.web = web
      self.characters = characters
      self.teams = teams
      self.locations = locations
      self.scanInformation = scanInformation
      self.storyArc = storyArc
      self.storyArcNumber = storyArcNumber
      self.seriesGroup = seriesGroup
      self.mainCharacterOrTeam = mainCharacterOrTeam
      self.review = review
      self.communityRating = communityRating
      self.blackAndWhite = blackAndWhite
      self.manga = manga
      self.ageRating = ageRating
      self.year = year
      self.month = month
      self.day = day
      self.alternateCount = alternateCount
      self.pageCount = pageCount
    }

    /// Load Issue from an XML string
    public static func load(fromXML xmlString: String) throws -> Issue {
      guard let data = xmlString.data(using: .utf8) else {
        throw NSError(domain: "ComicInfo", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not convert XML to data"])
      }

      let document = try XMLDocument(data: data, options: [])
      let root = document.rootElement()

      let title = root?.elements(forName: "Title").first?.stringValue
      let series = root?.elements(forName: "Series").first?.stringValue
      let number = root?.elements(forName: "Number").first?.stringValue
      let count = root?.elements(forName: "Count").first?.stringValue.flatMap { Int($0) }
      let volume = root?.elements(forName: "Volume").first?.stringValue.flatMap { Int($0) }
      let summary = root?.elements(forName: "Summary").first?.stringValue
      let notes = root?.elements(forName: "Notes").first?.stringValue
      let writer = root?.elements(forName: "Writer").first?.stringValue
      let penciller = root?.elements(forName: "Penciller").first?.stringValue
      let inker = root?.elements(forName: "Inker").first?.stringValue
      let colorist = root?.elements(forName: "Colorist").first?.stringValue
      let letterer = root?.elements(forName: "Letterer").first?.stringValue
      let coverArtist = root?.elements(forName: "CoverArtist").first?.stringValue
      let editor = root?.elements(forName: "Editor").first?.stringValue
      let translator = root?.elements(forName: "Translator").first?.stringValue
      let publisher = root?.elements(forName: "Publisher").first?.stringValue
      let imprint = root?.elements(forName: "Imprint").first?.stringValue
      let format = root?.elements(forName: "Format").first?.stringValue
      let languageISO = root?.elements(forName: "LanguageISO").first?.stringValue
      let alternateSeries = root?.elements(forName: "AlternateSeries").first?.stringValue
      let alternateNumber = root?.elements(forName: "AlternateNumber").first?.stringValue
      let genre = root?.elements(forName: "Genre").first?.stringValue
      let web = root?.elements(forName: "Web").first?.stringValue
      let characters = root?.elements(forName: "Characters").first?.stringValue
      let teams = root?.elements(forName: "Teams").first?.stringValue
      let locations = root?.elements(forName: "Locations").first?.stringValue
      let scanInformation = root?.elements(forName: "ScanInformation").first?.stringValue
      let storyArc = root?.elements(forName: "StoryArc").first?.stringValue
      let storyArcNumber = root?.elements(forName: "StoryArcNumber").first?.stringValue
      let seriesGroup = root?.elements(forName: "SeriesGroup").first?.stringValue
      let mainCharacterOrTeam = root?.elements(forName: "MainCharacterOrTeam").first?.stringValue
      let review = root?.elements(forName: "Review").first?.stringValue
      let communityRating = root?.elements(forName: "CommunityRating").first?.stringValue.flatMap { Double($0) }
      let blackAndWhite = root?.elements(forName: "BlackAndWhite").first?.stringValue
      let manga = root?.elements(forName: "Manga").first?.stringValue
      let ageRating = root?.elements(forName: "AgeRating").first?.stringValue
      let year = root?.elements(forName: "Year").first?.stringValue.flatMap { Int($0) }
      let month = root?.elements(forName: "Month").first?.stringValue.flatMap { Int($0) }
      let day = root?.elements(forName: "Day").first?.stringValue.flatMap { Int($0) }
      let alternateCount = root?.elements(forName: "AlternateCount").first?.stringValue.flatMap { Int($0) }
      let pageCount = root?.elements(forName: "PageCount").first?.stringValue.flatMap { Int($0) }

      return Issue(
        title: title,
        series: series,
        number: number,
        count: count,
        volume: volume,
        summary: summary,
        notes: notes,
        writer: writer,
        penciller: penciller,
        inker: inker,
        colorist: colorist,
        letterer: letterer,
        coverArtist: coverArtist,
        editor: editor,
        translator: translator,
        publisher: publisher,
        imprint: imprint,
        format: format,
        languageISO: languageISO,
        alternateSeries: alternateSeries,
        alternateNumber: alternateNumber,
        genre: genre,
        web: web,
        characters: characters,
        teams: teams,
        locations: locations,
        scanInformation: scanInformation,
        storyArc: storyArc,
        storyArcNumber: storyArcNumber,
        seriesGroup: seriesGroup,
        mainCharacterOrTeam: mainCharacterOrTeam,
        review: review,
        communityRating: communityRating,
        blackAndWhite: blackAndWhite,
        manga: manga,
        ageRating: ageRating,
        year: year,
        month: month,
        day: day,
        alternateCount: alternateCount,
        pageCount: pageCount)
    }
  }
}
