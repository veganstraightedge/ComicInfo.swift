//
// main.swift
// ComicInfoCLI
//

import ComicInfo
import Foundation

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

  var fileExtension: String {
    switch self {
    case .json: return "json"
    case .xml: return "xml"
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
        throw CLIError(message: "Usage: comicinfo read <file>")
      }
      return .read(args[1])

    case "write", "create":
      guard args.count >= 3 else {
        throw CLIError(message: "Usage: comicinfo write <input-json> <output-xml>")
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
        throw CLIError(message: "Usage: comicinfo validate <file>")
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
    case .read(let filePath):
      try readCommand(filePath)

    case .write(let inputPath, let outputPath):
      try writeCommand(inputPath, outputPath)

    case .convert(let inputPath, let outputPath, let format):
      try convertCommand(inputPath, outputPath, format)

    case .validate(let filePath):
      try validateCommand(filePath)

    case .version:
      versionCommand()

    case .help:
      helpCommand()
    }
  }

  static func readCommand(_ filePath: String) throws {
    let issue = try ComicInfo.load(from: filePath)

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
        var pageInfo = "Page \(page.image): \(page.type.stringValue)"
        if page.isDoublePage { pageInfo += " (double)" }
        if page.isBookmarked { pageInfo += " (bookmarked)" }
        print(pageInfo)
      }
    }
  }

  static func writeCommand(_ inputPath: String, _ outputPath: String) throws {
    let jsonData = try Data(contentsOf: URL(fileURLWithPath: inputPath))
    let decoder = JSONDecoder()
    let issue = try decoder.decode(ComicInfo.Issue.self, from: jsonData)

    let xmlString = try issue.toXMLString()
    try xmlString.write(to: URL(fileURLWithPath: outputPath), atomically: true, encoding: .utf8)

    print("Created ComicInfo.xml at: \(outputPath)")
  }

  static func convertCommand(_ inputPath: String, _ outputPath: String, _ format: OutputFormat) throws {
    let issue = try ComicInfo.load(from: inputPath)

    switch format {
    case .json:
      let jsonData = try issue.toJSONData()
      try jsonData.write(to: URL(fileURLWithPath: outputPath))
      print("Converted to JSON: \(outputPath)")

    case .xml:
      let xmlString = try issue.toXMLString()
      try xmlString.write(to: URL(fileURLWithPath: outputPath), atomically: true, encoding: .utf8)
      print("Converted to XML: \(outputPath)")
    }
  }

  static func validateCommand(_ filePath: String) throws {
    do {
      let issue = try ComicInfo.load(from: filePath)
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
    print("comicinfo \(Version.current)")
    print("ComicInfo Swift Package")
  }

  static func helpCommand() {
    print(
      """
      comicinfo - ComicInfo.xml command line tool

      USAGE:
          comicinfo <command> [arguments]

      COMMANDS:
          read <file>                    Display comic information
          validate <file>                Validate ComicInfo.xml file
          convert <input> <output> <fmt> Convert between formats
          write <json> <xml>             Create ComicInfo.xml from JSON
          version                        Show version information
          help                           Show this help message

      EXAMPLES:
          comicinfo read ComicInfo.xml
          comicinfo validate /path/to/ComicInfo.xml
          comicinfo convert ComicInfo.xml comic.json json
          comicinfo write comic.json ComicInfo.xml

      FORMATS:
          json    JSON format
          xml     ComicInfo.xml format
      """)
  }

  static func printError(_ message: String) {
    FileHandle.standardError.write("Error: \(message)\n".data(using: .utf8)!)
  }
}

CLI.main()
