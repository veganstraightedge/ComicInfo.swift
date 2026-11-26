//
// Match.swift
// ComicInfo
//

import Foundation

extension ComicInfo {
  /// One issue a `MetadataSource` found that might be the comic being looked up.
  ///
  /// It holds what a person needs to pick the right one from a list, and the source's own ID to
  /// fetch the rest with `MetadataSource.issue(for:)`.
  public struct Match: Equatable, Hashable, Sendable, Identifiable {
    /// The source's ID for the issue.
    public let id: String
    /// How the match is listed, such as "Saga (2012) #1".
    public let heading: String
    /// The series name, as the source writes it.
    public let series: String
    /// The issue number, as the source writes it.
    public let number: String?
    /// The cover date, as the source writes it, usually "2012-03-01".
    public let coverDate: String?
    /// The issue's title.
    public let title: String?
    /// More to tell matches apart, such as "Image · Cover date 2012-03-01".
    public let details: String?
    /// The issue's page on the source's site.
    public let siteURL: URL?

    public init(
      id: String,
      heading: String,
      series: String,
      number: String? = nil,
      coverDate: String? = nil,
      title: String? = nil,
      details: String? = nil,
      siteURL: URL? = nil
    ) {
      self.id = id
      self.heading = heading
      self.series = series
      self.number = number
      self.coverDate = coverDate
      self.title = title
      self.details = details
      self.siteURL = siteURL
    }
  }
}

extension Array where Element == ComicInfo.Match {
  /// The matches, best first, for looking up `issue`.
  ///
  /// A series named exactly as the issue's (ignoring case and surrounding space) counts most, then
  /// a cover dated in the issue's year. So a wrong year, from a file name say, can only reorder the
  /// right match, never hide it. Otherwise the source's own order stands.
  public func ranked(for issue: ComicInfo.Issue) -> [ComicInfo.Match] {
    let series = issue.series.map(Self.normalized)
    let yearPrefix = issue.year.map { "\($0)-" }

    func score(_ match: ComicInfo.Match) -> Int {
      var points = 0
      if let series, Self.normalized(match.series) == series { points += 2 }
      if let yearPrefix, match.coverDate?.hasPrefix(yearPrefix) == true { points += 1 }
      return points
    }

    return enumerated()
      .sorted { left, right in
        let (leftScore, rightScore) = (score(left.element), score(right.element))
        return leftScore == rightScore ? left.offset < right.offset : leftScore > rightScore
      }
      .map(\.element)
  }

  private static func normalized(_ name: String) -> String {
    name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
  }
}
