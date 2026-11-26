//
// MetadataSource.swift
// ComicInfo
//

import Foundation

extension ComicInfo {
  /// An online comics database that a comic's details can be looked up in.
  ///
  /// Each database has its own package, built on this one, such as ComicInfoComicVine. They all
  /// work the same way:
  ///
  /// ```swift
  /// if let missing = source.missingDetails(for: issue) {
  ///   // Ask for what's missing, such as a year.
  /// }
  /// let matches = try await source.matches(for: issue)    // best first
  /// let found = try await source.issue(for: matches[0])   // after a person picks one
  /// let updated = issue.fillingBlanks(from: found)
  /// ```
  ///
  /// Every database asks that what is shown from it credits it and links to it: use `name` and
  /// `homeURL`.
  public protocol MetadataSource: Sendable {
    /// The database's name, such as "Comic Vine".
    var name: String { get }

    /// The database's home page, to link to when showing its data.
    var homeURL: URL { get }

    /// What `issue` still needs before this database can be searched for it, in a sentence a
    /// person can act on, or `nil` when it can be searched.
    func missingDetails(for issue: ComicInfo.Issue) -> String?

    /// The issues in this database that might be `issue`, best first (see `ranked(for:)`).
    func matches(for issue: ComicInfo.Issue) async throws -> [ComicInfo.Match]

    /// Everything this database knows about the issue `match` found, as an issue.
    ///
    /// Combine it with what the comic already has using `Issue.fillingBlanks(from:)`.
    func issue(for match: ComicInfo.Match) async throws -> ComicInfo.Issue
  }
}
