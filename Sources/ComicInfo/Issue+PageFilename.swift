//
// Issue+PageFilename.swift
// ComicInfo
//

import Foundation

extension ComicInfo.Issue {
  /// The names that `pageFilename(template:page:of:)` fills in: `filenameTokens` and `page`.
  public static let pageFilenameTokens = filenameTokens + ["page"]

  /// A file name for one of this issue's page images, made by filling in `template`.
  ///
  /// ```swift
  /// issue.pageFilename(template: "page_{page:3}", page: 1, of: 22)  // "page_001"
  /// issue.pageFilename(template: "{series}_{number:3}_{page:4}", page: 12, of: 22)  // "Saga_007_0012"
  /// ```
  ///
  /// `{page}` is the page number, and `{page:3}` pads it with zeros to that many digits (1 to 99).
  /// The other tokens are those of `filename(template:)`, filled in the same way.
  ///
  /// Page files are read in name order, so the result always keeps pages apart and in order:
  /// - The page number is at least as wide as `pageCount`, whatever width the template asks for:
  ///   page 2 of 10 is `02`.
  /// - A template with no page number gets one appended after `_`, and a name that would be empty
  ///   is the page number alone.
  ///
  /// The result has no file extension. `/` and `:` anywhere in it become `-`.
  ///
  /// - Parameters:
  ///   - template: Text containing `{name}` tokens from `pageFilenameTokens`.
  ///   - page: The page's number, counting from 1.
  ///   - pageCount: How many pages the comic has.
  /// - Returns: The file name for the page.
  public func pageFilename(template: String, page: Int, of pageCount: Int) -> String {
    let minimumWidth = String(max(page, pageCount)).count
    let number = Self.zeroPadded(String(page), to: minimumWidth)

    let numbered = Self.filling("page", with: number, in: template)
      .replacingOccurrences(of: "{page}", with: number)
    let name = filename(template: numbered)

    let complete: String
    if numbered != template {
      complete = name
    } else if name.isEmpty {
      complete = number
    } else {
      complete = "\(name)_\(number)"
    }

    return
      complete
      .replacingOccurrences(of: "/", with: "-")
      .replacingOccurrences(of: ":", with: "-")
  }
}
