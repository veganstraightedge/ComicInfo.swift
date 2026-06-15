//
// Errors.swift
// ComicInfo
//

import Foundation

/// Errors that can occur during ComicInfo parsing and processing.
///
/// All ComicInfo operations throw errors conforming to this enum, providing
/// detailed information about what went wrong and how to fix it.
///
/// ## Usage
/// ```swift
/// do {
///   let issue = try ComicInfo.load(from: "ComicInfo.xml")
/// } catch ComicInfoError.fileError(let message) {
///   print("File error: \(message)")
/// } catch ComicInfoError.parseError(let message) {
///   print("Parse error: \(message)")
/// }
/// ```
public enum ComicInfoError: Error, Equatable {
  /// XML parsing failed due to malformed XML or missing required elements
  case parseError(String)

  /// File system error occurred (file not found, permission denied, etc.)
  case fileError(String)

  /// Invalid value for an enum field with list of valid values
  case invalidEnum(field: String, value: String, validValues: [String])

  /// Numeric value outside allowed range
  case rangeError(field: String, value: String, min: String, max: String)

  /// Cannot convert string value to expected type (Int, Double, etc.)
  case typeCoercionError(field: String, value: String, expectedType: String)

  /// ComicInfo schema validation error
  case schemaError(String)
}

extension ComicInfoError: LocalizedError {
  /// Localized error message describing what went wrong.
  public var errorDescription: String? {
    switch self {
    case .parseError(let message):
      return "Parse error: \(message)"
    case .fileError(let message):
      return "File error: \(message)"
    case .invalidEnum(let field, let value, let validValues):
      return "Invalid value '\(value)' for field '\(field)'. Valid values are: \(validValues.joined(separator: ", "))"
    case .rangeError(let field, let value, let min, let max):
      return "Value '\(value)' for field '\(field)' is out of range (\(min)..\(max))"
    case .typeCoercionError(let field, let value, let expectedType):
      return "Cannot convert value '\(value)' for field '\(field)' to \(expectedType)"
    case .schemaError(let message):
      return "Schema error: \(message)"
    }
  }
}
