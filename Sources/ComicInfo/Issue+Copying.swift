//
// Issue+Copying.swift
// ComicInfo
//

import Foundation

extension ComicInfo.Issue {
  /// A copy of the issue with these values in place of its own; every other field is the same.
  func copying(
    charactersRawData: String?,
    genreRawData: String?,
    locationsRawData: String?,
    teamsRawData: String?,
    webRawData: String?,
    pageCount: Int?,
    pages: [ComicInfo.Page]
  ) -> ComicInfo.Issue {
    ComicInfo.Issue(
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
      pages: pages
    )
  }
}
