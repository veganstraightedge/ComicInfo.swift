//
// NumericField.swift
// ComicInfo
//

import Foundation

extension ComicInfo {
  /// The ComicInfo fields that hold a number, with the rules a value must meet.
  ///
  /// Use it to check text before it becomes part of an `Issue`, for example text typed into a form:
  /// ```swift
  /// try ComicInfo.NumericField.year.validate("86")
  /// // throws ComicInfoError.rangeError(field: "Year", value: "86", min: "1000", max: "9999")
  ///
  /// let year = try ComicInfo.NumericField.year.int(from: "1986")  // 1986
  /// ```
  ///
  /// Blank text is always valid: the field is simply absent.
  public enum NumericField: String, CaseIterable, Sendable {
    case alternateCount
    case communityRating
    case count
    case day
    case month
    case pageCount
    case volume
    case year

    /// The field's element name in the ComicInfo schema, e.g. `AlternateCount`.
    public var elementName: String {
      switch self {
      case .alternateCount: "AlternateCount"
      case .communityRating: "CommunityRating"
      case .count: "Count"
      case .day: "Day"
      case .month: "Month"
      case .pageCount: "PageCount"
      case .volume: "Volume"
      case .year: "Year"
      }
    }

    /// Checks that `text` is blank or a number this field accepts.
    ///
    /// - Throws: `ComicInfoError.typeCoercionError` when `text` is not a number of the field's type,
    ///   `ComicInfoError.rangeError` when it is outside the field's range.
    public func validate(_ text: String) throws {
      switch self {
      case .communityRating: _ = try double(from: text)
      case .alternateCount, .count, .day, .month, .pageCount, .volume, .year: _ = try int(from: text)
      }
    }

    /// The whole number in `text`, or nil when `text` is blank.
    ///
    /// - Throws: `ComicInfoError.typeCoercionError` when `text` is not a whole number,
    ///   `ComicInfoError.rangeError` when it is outside the field's range.
    public func int(from text: String) throws -> Int? {
      let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !trimmed.isEmpty else { return nil }

      guard let number = Int(trimmed) else {
        throw ComicInfoError.typeCoercionError(field: elementName, value: text, expectedType: "Int")
      }
      try checkRange(Double(number), text: text)
      return number
    }

    /// The number in `text`, or nil when `text` is blank.
    ///
    /// - Throws: `ComicInfoError.typeCoercionError` when `text` is not a number,
    ///   `ComicInfoError.rangeError` when it is outside the field's range.
    public func double(from text: String) throws -> Double? {
      let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !trimmed.isEmpty else { return nil }

      guard let number = Double(trimmed) else {
        throw ComicInfoError.typeCoercionError(field: elementName, value: text, expectedType: "Double")
      }
      try checkRange(number, text: text)
      return number
    }

    /// The smallest and largest accepted values, with the text used to report them.
    private var limits: (range: ClosedRange<Double>, min: String, max: String)? {
      switch self {
      case .communityRating: (0.0...5.0, "0.0", "5.0")
      case .day: (1...31, "1", "31")
      case .month: (1...12, "1", "12")
      case .year: (1000...9999, "1000", "9999")
      case .alternateCount, .count, .pageCount, .volume: nil
      }
    }

    private func checkRange(_ number: Double, text: String) throws {
      guard let limits, !limits.range.contains(number) else { return }
      throw ComicInfoError.rangeError(field: elementName, value: text, min: limits.min, max: limits.max)
    }
  }
}
