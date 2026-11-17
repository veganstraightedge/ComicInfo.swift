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
  /// Write `{number:3}` to pad the issue number with zeros to that many digits. Only the whole
  /// number it starts with is padded, and a number that does not start with one is left alone:
  /// ```swift
  /// issue.filename(template: "{series} #{number:3}")  // "Saga #001", "Saga #001.5", "Saga #012AU"
  /// ```
  /// The width is from 1 to 99 and works on `{number}` only.
  ///
  /// The result has no file extension. A value the issue lacks is left out, along with decoration
  /// that would be left empty around it: `Saga # ()` becomes `Saga`. `/` and `:` in a value become
  /// `-`, since they cannot be part of a file name. Anything else in the template, including a
  /// `{name}` that is not one of `filenameTokens`, is kept as written.
  ///
  /// - Parameter template: Text containing `{name}` tokens from `filenameTokens`.
  /// - Returns: The file name, which is empty when the issue has none of the values asked for.
  public func filename(template: String) -> String {
    var name = fillingPaddedNumbers(in: template)
    for token in Self.filenameTokens {
      name = name.replacingOccurrences(of: "{\(token)}", with: filenameValue(for: token))
    }
    return Self.tidied(name)
  }

  /// Fills in each `{number:width}`, leaving one whose width is not 1 to 99 as written.
  private func fillingPaddedNumbers(in template: String) -> String {
    let opening = "{number:"
    var name = template
    var searchStart = name.startIndex

    while let open = name.range(of: opening, range: searchStart..<name.endIndex) {
      guard let close = name.range(of: "}", range: open.upperBound..<name.endIndex) else { break }

      let digits = name[open.upperBound..<close.lowerBound]
      guard
        (1...2).contains(digits.count), digits.allSatisfy({ $0.isASCII && $0.isNumber }),
        let width = Int(digits), width > 0
      else {
        searchStart = open.upperBound
        continue
      }

      let value = Self.zeroPadded(filenameValue(for: "number"), to: width)
      name.replaceSubrange(open.lowerBound..<close.upperBound, with: value)
      searchStart = name.index(open.lowerBound, offsetBy: value.count)
    }
    return name
  }

  /// Pads the whole number that `value` starts with to `width` digits: `1.5` to `001.5` for 3.
  private static func zeroPadded(_ value: String, to width: Int) -> String {
    let whole = value.prefix { $0.isASCII && $0.isNumber }
    guard !whole.isEmpty, whole.count < width else { return value }
    return String(repeating: "0", count: width - whole.count) + value
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
