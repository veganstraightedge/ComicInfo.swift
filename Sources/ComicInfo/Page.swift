//
// Page.swift
// ComicInfo
//

extension ComicInfo {
  /// Represents a single page in a comic book with metadata.
  public struct Page: Equatable, Hashable, Codable {
    /// Page number or index (0-based)
    public let image: Int

    /// Type classifications of this page.
    ///
    /// The XSD `ComicPageType` is an `xs:list`, so the `Type` attribute may be a
    /// space-separated list of values; order is preserved. Defaults to `[.story]`.
    public let types: [PageType]

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

    /// Initialize a new Page with one or more type classifications.
    ///
    /// ## Usage
    /// ```swift
    /// let coverPage = ComicInfo.Page(image: 0, types: [.frontCover])
    /// let bothPage = ComicInfo.Page(image: 1, types: [.frontCover, .story])
    /// ```
    ///
    /// - Parameters:
    ///   - image: Page number/index (0-based)
    ///   - types: Page type classifications (defaults to [.story])
    ///   - doublePage: True if this is a double-page spread (defaults to false)
    ///   - imageSize: File size in bytes (defaults to 0)
    ///   - key: Key/identifier string (defaults to empty)
    ///   - bookmark: Bookmark text (defaults to empty)
    ///   - imageWidth: Image width in pixels (defaults to -1 for unknown)
    ///   - imageHeight: Image height in pixels (defaults to -1 for unknown)
    public init(
      image: Int,
      types: [PageType] = [.story],
      doublePage: Bool = false,
      imageSize: Int = 0,
      key: String = "",
      bookmark: String = "",
      imageWidth: Int = -1,
      imageHeight: Int = -1
    ) {
      self.image = image
      self.types = types
      self.doublePage = doublePage
      self.imageSize = imageSize
      self.key = key
      self.bookmark = bookmark
      self.imageWidth = imageWidth
      self.imageHeight = imageHeight
    }

    /// Convenience initializer for a single-type page.
    ///
    /// ```swift
    /// let storyPage = ComicInfo.Page(image: 1, type: .story, doublePage: true)
    /// ```
    public init(
      image: Int,
      type: PageType,
      doublePage: Bool = false,
      imageSize: Int = 0,
      key: String = "",
      bookmark: String = "",
      imageWidth: Int = -1,
      imageHeight: Int = -1
    ) {
      self.init(
        image: image,
        types: [type],
        doublePage: doublePage,
        imageSize: imageSize,
        key: key,
        bookmark: bookmark,
        imageWidth: imageWidth,
        imageHeight: imageHeight
      )
    }

    /// The page's primary type (the first of `types`), for the common single-type case.
    public var type: PageType {
      return types.first ?? .story
    }

    /// True if this page carries the given type.
    public func includesType(_ type: PageType) -> Bool {
      return types.contains(type)
    }

    /// True if this page is a cover page (any of its types is a cover type).
    public var isCover: Bool {
      return types.contains(where: \.isCover)
    }

    /// True if this page is a story page.
    public var isStory: Bool {
      return types.contains(where: \.isStory)
    }

    /// True if this page is deleted.
    public var isDeleted: Bool {
      return types.contains(where: \.isDeleted)
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
