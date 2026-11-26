import Foundation

extension ComicInfo.Issue {
  /// Every entry of `webRawData`, split on whitespace and kept as text.
  ///
  /// Unlike `webUrls`, entries that are not valid URLs are kept, so an editor shows
  /// everything the file holds and writes it back unchanged.
  public var webLinks: [String] {
    guard let webRawData else { return [] }
    return webRawData.split(whereSeparator: \.isWhitespace).map(String.init)
  }

  /// The same issue with these characters.
  ///
  /// Each name is trimmed, and empty names and repeats are dropped. A comma inside a name would
  /// split it in two when read back, so it becomes a space. An empty list removes the field.
  public func settingCharacters(_ characters: [String]) -> ComicInfo.Issue {
    copying(
      charactersRawData: Self.commaSeparated(characters),
      genreRawData: genreRawData,
      locationsRawData: locationsRawData,
      teamsRawData: teamsRawData,
      webRawData: webRawData,
      pageCount: pageCount,
      pages: pages
    )
  }

  /// The same issue with these genres.
  ///
  /// Each genre is trimmed, and empty genres and repeats are dropped. A comma inside a genre
  /// would split it in two when read back, so it becomes a space. An empty list removes the field.
  public func settingGenres(_ genres: [String]) -> ComicInfo.Issue {
    copying(
      charactersRawData: charactersRawData,
      genreRawData: Self.commaSeparated(genres),
      locationsRawData: locationsRawData,
      teamsRawData: teamsRawData,
      webRawData: webRawData,
      pageCount: pageCount,
      pages: pages
    )
  }

  /// The same issue with these locations.
  ///
  /// Each location is trimmed, and empty locations and repeats are dropped. A comma inside a
  /// location would split it in two when read back, so it becomes a space. An empty list removes
  /// the field.
  public func settingLocations(_ locations: [String]) -> ComicInfo.Issue {
    copying(
      charactersRawData: charactersRawData,
      genreRawData: genreRawData,
      locationsRawData: Self.commaSeparated(locations),
      teamsRawData: teamsRawData,
      webRawData: webRawData,
      pageCount: pageCount,
      pages: pages
    )
  }

  /// The same issue with these teams.
  ///
  /// Each team is trimmed, and empty teams and repeats are dropped. A comma inside a team would
  /// split it in two when read back, so it becomes a space. An empty list removes the field.
  public func settingTeams(_ teams: [String]) -> ComicInfo.Issue {
    copying(
      charactersRawData: charactersRawData,
      genreRawData: genreRawData,
      locationsRawData: locationsRawData,
      teamsRawData: Self.commaSeparated(teams),
      webRawData: webRawData,
      pageCount: pageCount,
      pages: pages
    )
  }

  /// The same issue with these web links.
  ///
  /// A link with whitespace in it becomes several links, as it would be read back. Empty links
  /// and repeats are dropped. An empty list removes the field.
  public func settingWebLinks(_ links: [String]) -> ComicInfo.Issue {
    let split = links.flatMap { $0.split(whereSeparator: \.isWhitespace).map(String.init) }
    return copying(
      charactersRawData: charactersRawData,
      genreRawData: genreRawData,
      locationsRawData: locationsRawData,
      teamsRawData: teamsRawData,
      webRawData: Self.joined(split, separator: " "),
      pageCount: pageCount,
      pages: pages
    )
  }

  private static func commaSeparated(_ values: [String]) -> String? {
    let cleaned = values.map { value in
      value
        .replacingOccurrences(of: ",", with: " ")
        .split(whereSeparator: \.isWhitespace)
        .joined(separator: " ")
    }
    return joined(cleaned, separator: ", ")
  }

  private static func joined(_ values: [String], separator: String) -> String? {
    var seen = Set<String>()
    let kept = values.filter { !$0.isEmpty && seen.insert($0).inserted }
    return kept.isEmpty ? nil : kept.joined(separator: separator)
  }
}
