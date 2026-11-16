//
// Issue+Filename.swift
// ComicInfo
//

import Foundation

extension ComicInfo.Issue {
  /// The names that `filename(template:)` fills in, written in a template as `{name}`.
  public static let filenameTokens = ["number", "publisher", "series", "title", "volume", "year"]

  /// A file name for this issue, made by filling in `template`.
  ///
  /// ```swift
  /// issue.filename(template: "{series} #{number} ({year})")  // "Saga #1 (2012)"
  /// ```
  ///
  /// The result has no file extension. A value the issue lacks is left out, along with decoration
  /// that would be left empty around it: `Saga # ()` becomes `Saga`. `/` and `:` in a value become
  /// `-`, since they cannot be part of a file name. Anything else in the template, including a
  /// `{name}` that is not one of `filenameTokens`, is kept as written.
  ///
  /// - Parameter template: Text containing `{name}` tokens from `filenameTokens`.
  /// - Returns: The file name, which is empty when the issue has none of the values asked for.
  public func filename(template: String) -> String {
    var name = template
    for token in Self.filenameTokens {
      name = name.replacingOccurrences(of: "{\(token)}", with: filenameValue(for: token))
    }
    return Self.tidied(name)
  }

  private func filenameValue(for token: String) -> String {
    let value: String? =
      switch token {
      case "number": number
      case "publisher": publisher
      case "series": series
      case "title": title
      case "volume": volume.map(String.init)
      case "year": year.map(String.init)
      default: nil
      }

    return (value ?? "")
      .replacingOccurrences(of: "/", with: "-")
      .replacingOccurrences(of: ":", with: "-")
      .trimmingCharacters(in: .whitespacesAndNewlines)
  }

  /// Removes decoration left empty by missing values, then collapses whitespace.
  private static func tidied(_ name: String) -> String {
    var tidy = name
    for empty in ["()", "[]"] {
      tidy = tidy.replacingOccurrences(of: empty, with: "")
    }

    let words = tidy.split(whereSeparator: \.isWhitespace).filter { $0 != "#" }
    return words.joined(separator: " ")
  }
}
