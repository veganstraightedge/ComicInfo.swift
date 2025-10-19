//
// ComicInfo.swift
// ComicInfo
//

import Foundation

/// Main entry point for loading ComicInfo data
public enum ComicInfo {

  /// Load ComicInfo from an XML string
  public static func load(fromXML xmlString: String) throws -> Issue {
    return try Issue.load(fromXML: xmlString)
  }

  /// Represents a comic book issue with metadata from ComicInfo.xml
  public struct Issue {
    public let title: String?
    public let series: String?
    public let number: String?
    public let count: Int?
    public let volume: Int?
    public let summary: String?
    public let notes: String?

    public init(
      title: String? = nil, series: String? = nil, number: String? = nil, count: Int? = nil, volume: Int? = nil,
      summary: String? = nil, notes: String? = nil
    ) {
      self.title = title
      self.series = series
      self.number = number
      self.count = count
      self.volume = volume
      self.summary = summary
      self.notes = notes
    }

    /// Load Issue from an XML string
    public static func load(fromXML xmlString: String) throws -> Issue {
      guard let data = xmlString.data(using: .utf8) else {
        throw NSError(domain: "ComicInfo", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not convert XML to data"])
      }

      let document = try XMLDocument(data: data, options: [])
      let root = document.rootElement()

      let title = root?.elements(forName: "Title").first?.stringValue
      let series = root?.elements(forName: "Series").first?.stringValue
      let number = root?.elements(forName: "Number").first?.stringValue
      let count = root?.elements(forName: "Count").first?.stringValue.flatMap { Int($0) }
      let volume = root?.elements(forName: "Volume").first?.stringValue.flatMap { Int($0) }
      let summary = root?.elements(forName: "Summary").first?.stringValue
      let notes = root?.elements(forName: "Notes").first?.stringValue

      return Issue(
        title: title, series: series, number: number, count: count, volume: volume, summary: summary, notes: notes)
    }
  }
}
