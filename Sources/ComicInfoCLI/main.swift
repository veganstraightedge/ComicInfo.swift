//
// main.swift
// ComicInfoCLI
//

import ComicInfo
import Foundation
import Yams

struct CLIError: Error, LocalizedError {
  let message: String

  var errorDescription: String? {
    message
  }
}

enum Command {
  case read(String)
  case write(String, String)
  case convert(String, String, OutputFormat)
  case validate(String)
  case help
  case version
}

enum OutputFormat: String, CaseIterable {
  case json = "json"
  case xml = "xml"
  case yaml = "yaml"

  var fileExtension: String {
    switch self {
    case .json: return "json"
    case .xml: return "xml"
    case .yaml: return "yaml"
    }
  }
}

class CLI {
  static func main() {
    let arguments = Array(CommandLine.arguments.dropFirst())

    do {
      let command = try parseCommand(arguments)
      try executeCommand(command)
    } catch {
      printError(error.localizedDescription)
      exit(1)
    }
  }

  static func parseCommand(_ args: [String]) throws -> Command {
    guard !args.isEmpty else {
      return .help
    }

    let command = args[0].lowercased()

    switch command {
    case "read", "show", "info":
      guard args.count >= 2 else {
        throw CLIError(message: "Usage: comicinfo read <input>")
      }
      return .read(args[1])

    case "write", "create":
      guard args.count >= 3 else {
        throw CLIError(message: "Usage: comicinfo write <input-json-or-yaml> <output-xml>")
      }
      return .write(args[1], args[2])

    case "convert":
      guard args.count >= 4 else {
        throw CLIError(message: "Usage: comicinfo convert <input> <output> <format>")
      }
      guard let format = OutputFormat(rawValue: args[3].lowercased()) else {
        let formats = OutputFormat.allCases.map(\.rawValue).joined(separator: ", ")
        throw CLIError(message: "Invalid format. Supported: \(formats)")
      }
      return .convert(args[1], args[2], format)

    case "validate", "check":
      guard args.count >= 2 else {
        throw CLIError(message: "Usage: comicinfo validate <input>")
      }
      return .validate(args[1])

    case "version", "--version", "-v":
      return .version

    case "help", "--help", "-h":
      return .help

    default:
      throw CLIError(message: "Unknown command: \(command). Use 'comicinfo help' for usage.")
    }
  }

  static func executeCommand(_ command: Command) throws {
    switch command {
    case .read(let input):
      try readCommand(input)

    case .write(let inputPath, let outputPath):
      try writeCommand(inputPath, outputPath)

    case .convert(let input, let outputPath, let format):
      try convertCommand(input, outputPath, format)

    case .validate(let input):
      try validateCommand(input)

    case .version:
      versionCommand()

    case .help:
      helpCommand()
    }
  }

  // MARK: - Shared helpers

  /// Load an Issue from a file path, an XML string, or a URL (http://, https://, file://).
  static func loadIssue(from input: String) throws -> ComicInfo.Issue {
    if let url = URL(string: input), let scheme = url.scheme?.lowercased(),
      ["http", "https", "file"].contains(scheme)
    {
      return try ComicInfo.load(from: url)
    }
    return try ComicInfo.load(from: input)
  }

  /// Decode an Issue from a JSON or YAML file (YAML detected by .yaml/.yml extension, else JSON).
  static func decodeIssue(fromFile path: String) throws -> ComicInfo.Issue {
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    let lowercasedPath = path.lowercased()

    if lowercasedPath.hasSuffix(".yaml") || lowercasedPath.hasSuffix(".yml") {
      guard let yaml = String(data: data, encoding: .utf8) else {
        throw CLIError(message: "Could not read '\(path)' as UTF-8")
      }
      return try YAMLDecoder().decode(ComicInfo.Issue.self, from: yaml)
    }

    return try JSONDecoder().decode(ComicInfo.Issue.self, from: data)
  }

  /// Write a string to a file path, or to standard output when the path is "-".
  static func writeOutput(_ content: String, to path: String) throws {
    if path == "-" {
      print(content)
    } else {
      try content.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
    }
  }

  // MARK: - Commands

  static func readCommand(_ input: String) throws {
    let issue = try loadIssue(from: input)

    print("=== Comic Information ===")

    if let title = issue.title { print("Title: \(title)") }
    if let series = issue.series { print("Series: \(series)") }
    if let number = issue.number { print("Number: \(number)") }
    if let volume = issue.volume { print("Volume: \(volume)") }
    if let count = issue.count { print("Count: \(count)") }

    if let year = issue.year {
      var dateStr = "\(year)"
      if let month = issue.month {
        dateStr += "-\(String(format: "%02d", month))"
        if let day = issue.day {
          dateStr += "-\(String(format: "%02d", day))"
        }
      }
      print("Date: \(dateStr)")
    }

    if let publisher = issue.publisher { print("Publisher: \(publisher)") }
    if let writer = issue.writer { print("Writer: \(writer)") }
    if let penciller = issue.penciller { print("Penciller: \(penciller)") }
    if let colorist = issue.colorist { print("Colorist: \(colorist)") }

    if let ageRating = issue.ageRating { print("Age Rating: \(ageRating.stringValue)") }
    if let manga = issue.manga { print("Manga: \(manga.stringValue)") }
    if let blackAndWhite = issue.blackAndWhite { print("Black & White: \(blackAndWhite.stringValue)") }

    if !issue.characters.isEmpty { print("Characters: \(issue.characters.joined(separator: ", "))") }
    if !issue.teams.isEmpty { print("Teams: \(issue.teams.joined(separator: ", "))") }
    if !issue.genres.isEmpty { print("Genres: \(issue.genres.joined(separator: ", "))") }

    if let summary = issue.summary { print("Summary: \(summary)") }

    if issue.hasPages {
      print("\n=== Pages (\(issue.pages.count)) ===")
      for page in issue.pages {
        let typesValue = page.types.map(\.stringValue).joined(separator: " ")
        var pageInfo = "Page \(page.image): \(typesValue)"
        if page.isDoublePage { pageInfo += " (double)" }
        if page.isBookmarked { pageInfo += " (bookmarked)" }
        print(pageInfo)
      }
    }
  }

  static func writeCommand(_ inputPath: String, _ outputPath: String) throws {
    let issue = try decodeIssue(fromFile: inputPath)
    let xmlString = try issue.toXMLString()
    try writeOutput(xmlString, to: outputPath)

    if outputPath != "-" {
      print("Created ComicInfo.xml at: \(outputPath)")
    }
  }

  static func convertCommand(_ input: String, _ outputPath: String, _ format: OutputFormat) throws {
    let issue = try loadIssue(from: input)

    let output: String
    switch format {
    case .json: output = try issue.toJSONString()
    case .xml: output = try issue.toXMLString()
    case .yaml: output = try issue.toYAMLString()
    }

    try writeOutput(output, to: outputPath)

    if outputPath != "-" {
      print("Converted to \(format.rawValue.uppercased()): \(outputPath)")
    }
  }

  static func validateCommand(_ input: String) throws {
    do {
      let issue = try loadIssue(from: input)
      print("✅ Valid ComicInfo file")

      var warnings: [String] = []

      if issue.title == nil { warnings.append("Missing title") }
      if issue.series == nil { warnings.append("Missing series") }
      if issue.number == nil { warnings.append("Missing number") }
      if issue.year == nil { warnings.append("Missing year") }

      if !warnings.isEmpty {
        print("\n⚠️  Warnings:")
        for warning in warnings {
          print("  - \(warning)")
        }
      }

      if let title = issue.title, let series = issue.series {
        print("📖 \(series) #\(issue.number ?? "?") - \(title)")
      }

    } catch {
      print("❌ Invalid ComicInfo file: \(error.localizedDescription)")
      throw error
    }
  }

  static func versionCommand() {
    print("comicinfo \(ComicInfo.Version.current)")
    print("ComicInfo.swift Package")
  }

  static func helpCommand() {
    print(
      """
      comicinfo - ComicInfo.xml command line tool

      USAGE:
          comicinfo <command> [arguments]

      COMMANDS:
          read <input>                   Display comic information
          validate <input>               Validate ComicInfo.xml
          convert <input> <output> <fmt> Convert between formats
          write <input> <output>         Create ComicInfo.xml from JSON or YAML
          version                        Show version information
          help                           Show this help message

      INPUT:
          A file path, an XML string, or a URL (http://, https://, file://).

      OUTPUT:
          A file path, or - for standard output (convert / write).

      FORMATS:
          json    JSON format
          xml     ComicInfo.xml format
          yaml    YAML format

      EXAMPLES:
          comicinfo read ComicInfo.xml
          comicinfo read https://example.com/ComicInfo.xml
          comicinfo validate /path/to/ComicInfo.xml
          comicinfo convert ComicInfo.xml comic.yaml yaml
          comicinfo convert ComicInfo.xml - json
          comicinfo write comic.yaml ComicInfo.xml
      """)
  }

  static func printError(_ message: String) {
    FileHandle.standardError.write("Error: \(message)\n".data(using: .utf8)!)
  }
}

CLI.main()
