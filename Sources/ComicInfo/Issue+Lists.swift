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

  /// Joins a list (characters, teams, locations, genres, ...) into a comma-separated value.
  ///
  /// Each value is trimmed, and empty values and repeats are dropped. A comma inside a
  /// value would split it in two when read back, so it becomes a space.
  /// - Returns: The joined value, or `nil` when there is nothing to write.
  public static func joinedList(_ values: [String]) -> String? {
    let cleaned = values.map { value in
      value
        .replacingOccurrences(of: ",", with: " ")
        .split(whereSeparator: \.isWhitespace)
        .joined(separator: " ")
    }
    return joined(cleaned, separator: ", ")
  }

  /// Joins web links into a space-separated `webRawData` value.
  ///
  /// An entry with whitespace in it becomes several links, as it would be read back.
  /// Empty entries and repeats are dropped.
  /// - Returns: The joined value, or `nil` when there is nothing to write.
  public static func joinedWeb(_ links: [String]) -> String? {
    let split = links.flatMap { $0.split(whereSeparator: \.isWhitespace).map(String.init) }
    return joined(split, separator: " ")
  }

  private static func joined(_ values: [String], separator: String) -> String? {
    var seen = Set<String>()
    let kept = values.filter { !$0.isEmpty && seen.insert($0).inserted }
    return kept.isEmpty ? nil : kept.joined(separator: separator)
  }
}
