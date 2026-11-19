//
// Issue+PageType.swift
// ComicInfo
//

import Foundation

extension ComicInfo.Issue {
  /// The type of the page image at `index`.
  ///
  /// This is the primary type of that image's `<Page>` entry. A page with no entry is a story
  /// page, as the schema says.
  ///
  /// - Parameter index: The page image's index (0-based), as in `Page.image`.
  /// - Returns: The page's type.
  public func pageType(at index: Int) -> ComicInfo.PageType {
    pages.first { $0.image == index }?.type ?? .story
  }

  /// The same issue with the page image at `index` given the type `type`.
  ///
  /// ```swift
  /// let updated = issue.settingPageType(.frontCover, at: 0)
  /// ```
  ///
  /// - The page's entry keeps everything else it has (bookmark, sizes); `type` replaces all of the
  ///   types it had.
  /// - A page with no entry gets one, placed in image order.
  /// - Setting `.story` on a page with no entry changes nothing, since that is already its type.
  ///
  /// - Parameters:
  ///   - type: The type to give the page.
  ///   - index: The page image's index (0-based), as in `Page.image`.
  /// - Returns: A copy of the issue with `pages` updated.
  public func settingPageType(_ type: ComicInfo.PageType, at index: Int) -> ComicInfo.Issue {
    guard let position = pages.firstIndex(where: { $0.image == index }) else {
      guard type != .story else { return self }
      let added = pages + [ComicInfo.Page(image: index, type: type)]
      return withPages(added.sorted { $0.image < $1.image }, pageCount: pageCount)
    }

    var updated = pages
    updated[position] = pages[position].withTypes([type])
    return withPages(updated, pageCount: pageCount)
  }
}

extension ComicInfo.Page {
  /// The same page entry with different types.
  fileprivate func withTypes(_ types: [ComicInfo.PageType]) -> ComicInfo.Page {
    ComicInfo.Page(
      image: image,
      types: types,
      doublePage: doublePage,
      imageSize: imageSize,
      key: key,
      bookmark: bookmark,
      imageWidth: imageWidth,
      imageHeight: imageHeight
    )
  }
}
