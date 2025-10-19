//
// ComicInfo.swift
// ComicInfo
//

import Foundation

/// Main entry point for loading ComicInfo data
public enum ComicInfo {

  /// Load ComicInfo from an XML string
  public static func load(fromXML xmlString: String) throws -> Issue {
    guard let data = xmlString.data(using: .utf8) else {
      throw NSError(domain: "ComicInfo", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not convert XML to data"])
    }

    let document = try XMLDocument(data: data, options: [])
    let root = document.rootElement()

    let title = root?.elements(forName: "Title").first?.stringValue

    return Issue(title: title)
  }
}

/// Represents a comic book issue with metadata from ComicInfo.xml
public struct Issue {
  public let title: String?
  public let series: String?
  public let number: String?

  public init(title: String? = nil, series: String? = nil, number: String? = nil) {
    self.title = title
    self.series = series
    self.number = number
  }
}
