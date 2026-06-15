//
// ComicInfo.swift
// ComicInfo
//
// A Swift package for reading and writing ComicInfo.xml metadata files.
//
// This package provides a complete implementation of the ComicInfo v2.0 schema
// for parsing and generating comic book metadata XML files.
//

import Foundation

/// Main entry point for loading ComicInfo data.
public enum ComicInfo {

  /// Load ComicInfo from an XML string.
  ///
  /// Parses ComicInfo XML content directly from a string, validating
  /// all fields according to the ComicInfo v2.0 schema.
  ///
  /// ## Usage
  /// ```swift
  /// let xml = """
  /// <ComicInfo>
  ///   <Title>Amazing Spider-Man</Title>
  ///   <Series>Amazing Spider-Man</Series>
  ///   <Number>1</Number>
  /// </ComicInfo>
  /// """
  /// let issue = try ComicInfo.load(fromXML: xml)
  /// ```
  ///
  /// - Parameter xmlString: Valid ComicInfo XML content
  /// - Returns: Parsed Issue with all metadata
  /// - Throws: ComicInfoError.parseError for invalid XML or schema violations
  public static func load(fromXML xmlString: String) throws -> Issue {
    return try Issue.load(fromXML: xmlString)
  }

  /// Load ComicInfo from a file path or XML string (smart detection).
  ///
  /// Automatically detects whether the input is a file path or XML content
  /// based on the string format, then loads appropriately.
  ///
  /// ## Detection Logic
  /// - Strings starting with `<` are treated as XML content
  /// - All other strings are treated as file paths
  ///
  /// ## Usage
  /// ```swift
  /// // Load from file path
  /// let issue1 = try ComicInfo.load(from: "/path/to/ComicInfo.xml")
  ///
  /// // Load from XML string
  /// let issue2 = try ComicInfo.load(from: "<ComicInfo><Title>Test</Title></ComicInfo>")
  /// ```
  ///
  /// - Parameter input: File path or XML string
  /// - Returns: Parsed Issue with all metadata
  /// - Throws: ComicInfoError for file access or parsing errors
  public static func load(from input: String) throws -> Issue {
    guard !input.isEmpty else {
      throw ComicInfoError.parseError("Input cannot be nil or empty")
    }

    guard looksLikeXML(input) else {
      return try loadFromFile(input)
    }
    return try load(fromXML: input)
  }

  /// Load ComicInfo from a URL.
  ///
  /// Synchronously loads and parses ComicInfo XML from a file URL.
  /// The file content is read as UTF-8 encoded text.
  ///
  /// ## Usage
  /// ```swift
  /// let url = URL(fileURLWithPath: "/path/to/ComicInfo.xml")
  /// let issue = try ComicInfo.load(from: url)
  /// ```
  ///
  /// - Parameter url: File URL pointing to ComicInfo.xml
  /// - Returns: Parsed Issue with all metadata
  /// - Throws: ComicInfoError.fileError for file access issues, parseError for XML issues
  public static func load(from url: URL) throws -> Issue {
    do {
      let xmlContent = try String(contentsOf: url, encoding: .utf8)
      return try load(fromXML: xmlContent)
    } catch let error as ComicInfoError {
      // Re-throw ComicInfo errors
      throw error
    } catch {
      throw ComicInfoError.fileError("Failed to read from URL '\(url)': \(error.localizedDescription)")
    }
  }

  /// Load ComicInfo from a URL asynchronously.
  ///
  /// Asynchronously loads and parses ComicInfo XML from any URL using URLSession.
  /// Supports both local file URLs and remote HTTP/HTTPS URLs.
  ///
  /// ## Usage
  /// ```swift
  /// let url = URL(string: "https://example.com/ComicInfo.xml")!
  /// let issue = try await ComicInfo.load(from: url)
  /// ```
  ///
  /// - Parameter url: Local file URL or remote HTTP/HTTPS URL
  /// - Returns: Parsed Issue with all metadata
  /// - Throws: ComicInfoError.fileError for network/file issues, parseError for XML issues
  @available(macOS 26, iOS 26, watchOS 26, tvOS 26, *)
  public static func load(from url: URL) async throws -> Issue {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      guard let xmlContent = String(data: data, encoding: .utf8) else {
        throw ComicInfoError.parseError("Could not decode data from URL '\(url)' as UTF-8")
      }
      return try load(fromXML: xmlContent)
    } catch let error as ComicInfoError {
      // Re-throw ComicInfo errors
      throw error
    } catch {
      throw ComicInfoError.fileError("Failed to load from URL '\(url)': \(error.localizedDescription)")
    }
  }

  /// Check if input looks like XML (starts with <).
  private static func looksLikeXML(_ input: String) -> Bool {
    return input.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("<")
  }

  /// Load from file path.
  private static func loadFromFile(_ filePath: String) throws -> Issue {
    try validateFilePath(filePath)

    guard FileManager.default.fileExists(atPath: filePath) else {
      throw ComicInfoError.fileError("File does not exist: '\(filePath)'")
    }

    do {
      let xmlContent = try String(contentsOfFile: filePath, encoding: .utf8)
      return try load(fromXML: xmlContent)
    } catch let error as ComicInfoError {
      // Re-throw ComicInfo errors
      throw error
    } catch {
      throw ComicInfoError.fileError("Failed to read file '\(filePath)': \(error.localizedDescription)")
    }
  }

  /// Validate file path to ensure it's not ambiguous with XML.
  private static func validateFilePath(_ input: String) throws {
    // Check for patterns that might be mistaken for XML or are clearly invalid paths
    if input.range(of: "^\\d+$", options: .regularExpression) != nil
      || (!input.contains(".") && !input.contains("/") && !input.contains("\\"))
    {
      throw ComicInfoError.parseError("Input '\(input)' does not appear to be valid XML or a file path")
    }
  }
}
