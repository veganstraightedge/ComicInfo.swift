//
// Page.swift
// ComicInfo
//

extension ComicInfo {
  /// Represents a single page in a comic book with metadata.
  public struct Page: Equatable, Hashable, Codable {
    /// Page number or index (0-based)
    public let image: Int

    /// Type classification of this page
    public let type: PageType

    /// True if this is a double-page spread
    public let doublePage: Bool

    /// File size in bytes (0 if unknown)
    public let imageSize: Int

    /// Optional key or identifier for the page
    public let key: String

    /// Bookmark text or annotation for the page
    public let bookmark: String

    /// Image width in pixels (-1 if unknown)
    public let imageWidth: Int

    /// Image height in pixels (-1 if unknown)
    public let imageHeight: Int

    /// Initialize a new Page with the specified attributes.
    ///
    /// ## Usage
    /// ```swift
    /// let coverPage = ComicInfo.Page(image: 0, type: .frontCover)
    /// let storyPage = ComicInfo.Page(image: 1, type: .story, doublePage: true)
    /// ```
    ///
    /// - Parameters:
    ///   - image: Page number/index (0-based)
    ///   - type: Page type classification (defaults to .story)
    ///   - doublePage: True if this is a double-page spread (defaults to false)
    ///   - imageSize: File size in bytes (defaults to 0)
    ///   - key: Key/identifier string (defaults to empty)
    ///   - bookmark: Bookmark text (defaults to empty)
    ///   - imageWidth: Image width in pixels (defaults to -1 for unknown)
    ///   - imageHeight: Image height in pixels (defaults to -1 for unknown)
    public init(
      image: Int,
      type: PageType = .story,
      doublePage: Bool = false,
      imageSize: Int = 0,
      key: String = "",
      bookmark: String = "",
      imageWidth: Int = -1,
      imageHeight: Int = -1
    ) {
      self.image = image
      self.type = type
      self.doublePage = doublePage
      self.imageSize = imageSize
      self.key = key
      self.bookmark = bookmark
      self.imageWidth = imageWidth
      self.imageHeight = imageHeight
    }

    /// True if this page is a cover page.
    public var isCover: Bool {
      return type.isCover
    }

    /// True if this page is a story page.
    public var isStory: Bool {
      return type.isStory
    }

    /// True if this page is deleted.
    public var isDeleted: Bool {
      return type.isDeleted
    }

    /// True if this is a double-page spread.
    public var isDoublePage: Bool {
      return doublePage
    }

    /// True if this page has a bookmark.
    public var isBookmarked: Bool {
      return !bookmark.isEmpty
    }

    /// Get image dimensions as optional values.
    public var dimensions: (width: Int?, height: Int?) {
      let width = imageWidth == -1 ? nil : imageWidth
      let height = imageHeight == -1 ? nil : imageHeight
      return (width: width, height: height)
    }

    /// True if both width and height dimensions are available.
    public var dimensionsAvailable: Bool {
      return imageWidth != -1 && imageHeight != -1
    }

    /// Calculate aspect ratio if dimensions are available.
    public var aspectRatio: Double? {
      guard dimensionsAvailable, imageHeight != 0 else {
        return nil
      }
      return Double(imageWidth) / Double(imageHeight)
    }
  }
}
