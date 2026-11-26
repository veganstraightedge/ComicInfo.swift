//
// Issue+RearrangingPages.swift
// ComicInfo
//

import Foundation

extension ComicInfo.Issue {
  /// The same issue after its page images were reordered, deleted, or added to.
  ///
  /// A `<Page>` entry points at its image by index, so when the images change the entries must
  /// follow. `order` describes the new images: `order[i]` is the index the image now at position `i`
  /// had before, or nil for an image that is new.
  ///
  /// ```swift
  /// // Three pages; the last is moved to the front and a new page is appended.
  /// let updated = issue.rearrangingPages([2, 0, 1, nil])
  /// ```
  ///
  /// - A page keeps its entry (type, bookmark, sizes) under its new index.
  /// - A deleted page loses its entry.
  /// - A page that had no entry still has none.
  /// - A new page gets a default entry, but only if the issue has page entries at all.
  /// - `pageCount` becomes the new number of pages, but only if it was set.
  ///
  /// - Parameter order: For each image in its new position, its previous index, or nil if new.
  /// - Returns: A copy of the issue with `pages` and `pageCount` brought up to date.
  public func rearrangingPages(_ order: [Int?]) -> ComicInfo.Issue {
    withPages(rearrangedPages(order), pageCount: pageCount == nil ? nil : order.count)
  }

  private func rearrangedPages(_ order: [Int?]) -> [ComicInfo.Page] {
    guard !pages.isEmpty else { return [] }

    var rearranged: [ComicInfo.Page] = []
    for (newIndex, previousIndex) in order.enumerated() {
      guard let previousIndex else {
        rearranged.append(ComicInfo.Page(image: newIndex))
        continue
      }
      guard let page = pages.first(where: { $0.image == previousIndex }) else { continue }
      rearranged.append(page.withImage(newIndex))
    }
    return rearranged
  }

  /// The same issue with different page entries and page count.
  func withPages(_ pages: [ComicInfo.Page], pageCount: Int?) -> ComicInfo.Issue {
    copying(
      charactersRawData: charactersRawData,
      genreRawData: genreRawData,
      locationsRawData: locationsRawData,
      teamsRawData: teamsRawData,
      webRawData: webRawData,
      pageCount: pageCount,
      pages: pages
    )
  }
}

extension ComicInfo.Page {
  /// The same page entry pointing at a different image index.
  fileprivate func withImage(_ image: Int) -> ComicInfo.Page {
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
