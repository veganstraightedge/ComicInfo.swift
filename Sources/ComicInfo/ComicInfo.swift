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
    public let year: Int?
    public let month: Int?
    public let day: Int?
    public let alternateCount: Int?
    public let pageCount: Int?

    public init(
      title: String? = nil, series: String? = nil, number: String? = nil, count: Int? = nil, volume: Int? = nil,
      summary: String? = nil, notes: String? = nil, writer: String? = nil, penciller: String? = nil,
      inker: String? = nil, colorist: String? = nil, letterer: String? = nil, coverArtist: String? = nil,
      editor: String? = nil, translator: String? = nil, publisher: String? = nil, imprint: String? = nil,
      format: String? = nil, languageISO: String? = nil, alternateSeries: String? = nil,
      alternateNumber: String? = nil, genre: String? = nil, web: String? = nil, year: Int? = nil,
      month: Int? = nil, day: Int? = nil, alternateCount: Int? = nil, pageCount: Int? = nil
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
      let year = root?.elements(forName: "Year").first?.stringValue.flatMap { Int($0) }
      let month = root?.elements(forName: "Month").first?.stringValue.flatMap { Int($0) }
      let day = root?.elements(forName: "Day").first?.stringValue.flatMap { Int($0) }
      let alternateCount = root?.elements(forName: "AlternateCount").first?.stringValue.flatMap { Int($0) }
      let pageCount = root?.elements(forName: "PageCount").first?.stringValue.flatMap { Int($0) }

      return Issue(
        title: title, series: series, number: number, count: count, volume: volume, summary: summary, notes: notes,
        writer: writer, penciller: penciller, inker: inker, colorist: colorist, letterer: letterer,
        coverArtist: coverArtist, editor: editor, translator: translator, publisher: publisher, imprint: imprint,
        format: format, languageISO: languageISO, alternateSeries: alternateSeries,
        alternateNumber: alternateNumber, genre: genre, web: web, year: year, month: month, day: day,
        alternateCount: alternateCount, pageCount: pageCount)
    }
  }
}
