//
// ComicInfo.swift
// ComicInfo
//

import Foundation

/// Main entry point for loading ComicInfo data
public enum ComicInfo {

  /// Load ComicInfo from an XML string
  public static func load(fromXML xmlString: String) throws -> Issue {
    return Issue()
  }
}

/// Represents a comic book issue with metadata from ComicInfo.xml
public struct Issue {
  public let title: String?

  public init(title: String? = nil) {
    self.title = title
  }
}
