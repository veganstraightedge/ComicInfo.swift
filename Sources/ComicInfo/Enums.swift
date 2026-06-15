//
// Enums.swift
// ComicInfo
//

extension ComicInfo {
  /// Manga enum representing manga reading direction.
  public enum Manga: String, CaseIterable, Equatable, Codable {
    case unknown = "Unknown"
    case no = "No"
    case yes = "Yes"
    case yesAndRightToLeft = "YesAndRightToLeft"

    /// String value for XML serialization.
    public var stringValue: String {
      return self.rawValue
    }

    /// Create from string, defaulting to unknown for invalid values.
    public static func from(string: String?) -> Manga {
      guard let string = string, !string.isEmpty else {
        return .unknown
      }
      return Manga(rawValue: string) ?? .unknown
    }

    /// Create from string with validation (throws on invalid values).
    public static func validated(from string: String) throws -> Manga {
      guard let manga = Manga(rawValue: string) else {
        throw ComicInfoError.invalidEnum(
          field: "Manga",
          value: string,
          validValues: Manga.allCases.map { $0.stringValue }
        )
      }
      return manga
    }

    /// True if this represents a manga (Yes or YesAndRightToLeft).
    public var isManga: Bool {
      return self == .yes || self == .yesAndRightToLeft
    }

    /// True if this represents right-to-left reading direction.
    public var isRightToLeft: Bool {
      return self == .yesAndRightToLeft
    }
  }

  /// Age rating classification for content appropriateness.
  ///
  /// Provides standardized age ratings compatible with various rating systems
  /// including ESRB, PEGI, and regional classification standards.
  ///
  /// ## Common Values
  /// - `.everyone`: Suitable for all ages
  /// - `.teen`: 13+ content
  /// - `.mature17Plus`: 17+ mature content
  /// - `.adultsOnly18Plus`: 18+ adult content only
  public enum AgeRating: String, CaseIterable, Equatable, Codable {
    case unknown = "Unknown"
    case adultsOnly18Plus = "Adults Only 18+"
    case earlyChildhood = "Early Childhood"
    case everyone = "Everyone"
    case everyone10Plus = "Everyone 10+"
    case g = "G"
    case kidsToAdults = "Kids to Adults"
    case m = "M"
    case ma15Plus = "MA15+"
    case mature17Plus = "Mature 17+"
    case pg = "PG"
    case r18Plus = "R18+"
    case ratingPending = "Rating Pending"
    case teen = "Teen"
    case x18Plus = "X18+"

    /// String value for XML serialization.
    public var stringValue: String {
      return self.rawValue
    }

    /// Create from string, defaulting to unknown for invalid values.
    public static func from(string: String?) -> AgeRating {
      guard let string = string, !string.isEmpty else {
        return .unknown
      }
      return AgeRating(rawValue: string) ?? .unknown
    }

    /// Create from string with validation (throws on invalid values).
    public static func validated(from string: String) throws -> AgeRating {
      guard let rating = AgeRating(rawValue: string) else {
        throw ComicInfoError.invalidEnum(
          field: "AgeRating",
          value: string,
          validValues: AgeRating.allCases.map { $0.stringValue }
        )
      }
      return rating
    }
  }

  /// Color format designation for the comic content.
  ///
  /// Indicates whether the comic is published in color or black & white.
  /// Used for filtering and display preferences in reading applications.
  ///
  /// ## Values
  /// - `.unknown`: Color format not specified
  /// - `.no`: Full color comic
  /// - `.yes`: Black and white comic
  public enum BlackAndWhite: String, CaseIterable, Equatable, Codable {
    case unknown = "Unknown"
    case no = "No"
    case yes = "Yes"

    /// String value for XML serialization.
    public var stringValue: String {
      return self.rawValue
    }

    /// Create from string, defaulting to unknown for invalid values.
    public static func from(string: String?) -> BlackAndWhite {
      guard let string = string, !string.isEmpty else {
        return .unknown
      }
      return BlackAndWhite(rawValue: string) ?? .unknown
    }

    /// Create from string with validation (throws on invalid values).
    public static func validated(from string: String) throws -> BlackAndWhite {
      guard let blackAndWhite = BlackAndWhite(rawValue: string) else {
        throw ComicInfoError.invalidEnum(
          field: "BlackAndWhite",
          value: string,
          validValues: BlackAndWhite.allCases.map { $0.stringValue }
        )
      }
      return blackAndWhite
    }

    /// True if this represents black and white.
    public var isBlackAndWhite: Bool {
      return self == .yes
    }
  }

  /// Page type enum for comic pages.
  public enum PageType: String, CaseIterable, Equatable, Codable {
    case frontCover = "FrontCover"
    case innerCover = "InnerCover"
    case roundup = "Roundup"
    case story = "Story"
    case advertisement = "Advertisement"
    case editorial = "Editorial"
    case letters = "Letters"
    case preview = "Preview"
    case backCover = "BackCover"
    case other = "Other"
    case deleted = "Deleted"

    /// String value for XML serialization.
    public var stringValue: String {
      return self.rawValue
    }

    /// Create from string, defaulting to story for invalid values.
    public static func from(string: String?) -> PageType {
      guard let string = string, !string.isEmpty else {
        return .story
      }
      return PageType(rawValue: string) ?? .story
    }

    /// Create from string with validation (throws on invalid values).
    public static func validated(from string: String) throws -> PageType {
      guard let pageType = PageType(rawValue: string) else {
        throw ComicInfoError.invalidEnum(
          field: "PageType",
          value: string,
          validValues: PageType.allCases.map { $0.stringValue }
        )
      }
      return pageType
    }

    /// True if this is a cover page type.
    public var isCover: Bool {
      return self == .frontCover || self == .backCover || self == .innerCover
    }

    /// True if this is a story page.
    public var isStory: Bool {
      return self == .story
    }

    /// True if this page is deleted.
    public var isDeleted: Bool {
      return self == .deleted
    }
  }
}
