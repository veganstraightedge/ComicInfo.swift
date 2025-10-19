//
// Issue.swift
// ComicInfo
//

import Foundation

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
