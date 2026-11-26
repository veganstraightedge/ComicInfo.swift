//
// Issue+FillingBlanks.swift
// ComicInfo
//

import Foundation

extension ComicInfo.Issue {
  /// The same issue with its blank fields filled in from `found`.
  ///
  /// Use it to add what a `MetadataSource` found to a comic's details without losing anything
  /// already there, read from the file or typed by a person:
  ///
  /// ```swift
  /// let found = try await source.issue(for: match)
  /// let updated = issue.fillingBlanks(from: found)
  /// ```
  ///
  /// - A field that is set is kept. A blank field (missing, only whitespace, or an `unknown` enum
  ///   value) takes `found`'s value.
  /// - Pages are kept as they are: a source knows nothing about this copy's page images. The page
  ///   count is taken from `found` only when this issue has none.
  ///
  /// - Parameter found: The issue to take values from.
  /// - Returns: A copy of the issue with its blanks filled.
  public func fillingBlanks(from found: ComicInfo.Issue) -> ComicInfo.Issue {
    ComicInfo.Issue(
      ageRating: Self.filled(ageRating, found.ageRating, unknown: .unknown),
      alternateCount: alternateCount ?? found.alternateCount,
      alternateNumber: Self.filled(alternateNumber, found.alternateNumber),
      alternateSeries: Self.filled(alternateSeries, found.alternateSeries),
      blackAndWhite: Self.filled(blackAndWhite, found.blackAndWhite, unknown: .unknown),
      charactersRawData: Self.filled(charactersRawData, found.charactersRawData),
      colorist: Self.filled(colorist, found.colorist),
      communityRating: communityRating ?? found.communityRating,
      count: count ?? found.count,
      coverArtist: Self.filled(coverArtist, found.coverArtist),
      day: day ?? found.day,
      editor: Self.filled(editor, found.editor),
      format: Self.filled(format, found.format),
      genreRawData: Self.filled(genreRawData, found.genreRawData),
      imprint: Self.filled(imprint, found.imprint),
      inker: Self.filled(inker, found.inker),
      languageISO: Self.filled(languageISO, found.languageISO),
      letterer: Self.filled(letterer, found.letterer),
      locationsRawData: Self.filled(locationsRawData, found.locationsRawData),
      mainCharacterOrTeam: Self.filled(mainCharacterOrTeam, found.mainCharacterOrTeam),
      manga: Self.filled(manga, found.manga, unknown: .unknown),
      month: month ?? found.month,
      notes: Self.filled(notes, found.notes),
      number: Self.filled(number, found.number),
      pageCount: pageCount ?? found.pageCount,
      penciller: Self.filled(penciller, found.penciller),
      publisher: Self.filled(publisher, found.publisher),
      review: Self.filled(review, found.review),
      scanInformation: Self.filled(scanInformation, found.scanInformation),
      series: Self.filled(series, found.series),
      seriesGroup: Self.filled(seriesGroup, found.seriesGroup),
      storyArc: Self.filled(storyArc, found.storyArc),
      storyArcNumber: Self.filled(storyArcNumber, found.storyArcNumber),
      summary: Self.filled(summary, found.summary),
      teamsRawData: Self.filled(teamsRawData, found.teamsRawData),
      title: Self.filled(title, found.title),
      translator: Self.filled(translator, found.translator),
      volume: volume ?? found.volume,
      webRawData: Self.filled(webRawData, found.webRawData),
      writer: Self.filled(writer, found.writer),
      year: year ?? found.year,
      pages: pages
    )
  }

  private static func filled(_ value: String?, _ found: String?) -> String? {
    guard let value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return found }
    return value
  }

  private static func filled<Value: Equatable>(_ value: Value?, _ found: Value?, unknown: Value) -> Value? {
    guard let value, value != unknown else { return found ?? value }
    return value
  }
}
