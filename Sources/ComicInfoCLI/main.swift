//
// main.swift
// ComicInfoCLI
//

import ArgumentParser
import ComicInfo
import Foundation
import Yams

// MARK: - Format

/// A ComicInfo data format.
enum DataFormat: String, CaseIterable, ExpressibleByArgument {
  case xml
  case json
  case yaml

  /// The format implied by a file extension, if recognized.
  init?(fileExtension: String) {
    switch fileExtension.lowercased() {
    case "xml": self = .xml
    case "json": self = .json
    case "yaml", "yml": self = .yaml
    default: return nil
    }
  }
}

/// Output-format shorthand flags: `--xml` / `--json` / `--yaml` / `--yml`.
enum FormatFlag: EnumerableFlag {
  case xml
  case json
  case yaml

  static func name(for value: FormatFlag) -> NameSpecification {
    switch value {
    case .xml: return [.customLong("xml")]
    case .json: return [.customLong("json")]
    case .yaml: return [.customLong("yaml"), .customLong("yml")]
    }
  }

  var dataFormat: DataFormat {
    switch self {
    case .xml: return .xml
    case .json: return .json
    case .yaml: return .yaml
    }
  }
}

// MARK: - Errors

enum CLIError: Error, LocalizedError {
  case notUTF8(String)

  var errorDescription: String? {
    switch self {
    case .notUTF8(let source): return "Input from '\(source)' is not valid UTF-8"
    }
  }
}

// MARK: - Loading / serializing

/// Load an Issue from a file path, a URL (https:// http:// file://), or an XML string,
/// detecting XML / JSON / YAML input by extension (or `<` prefix for an XML string).
func loadIssue(from input: String) throws -> ComicInfo.Issue {
  // URL
  if let url = URL(string: input), let scheme = url.scheme?.lowercased(),
    ["http", "https", "file"].contains(scheme)
  {
    if let format = DataFormat(fileExtension: url.pathExtension), format != .xml {
      return try decodeIssue(try Data(contentsOf: url), as: format, source: input)
    }
    return try ComicInfo.load(from: url)
  }

  // XML string
  if input.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("<") {
    return try ComicInfo.load(fromXML: input)
  }

  // File path
  let fileURL = URL(fileURLWithPath: input)
  if let format = DataFormat(fileExtension: fileURL.pathExtension), format != .xml {
    return try decodeIssue(try Data(contentsOf: fileURL), as: format, source: input)
  }
  return try ComicInfo.load(from: input)
}

/// Decode an Issue from JSON or YAML data.
func decodeIssue(_ data: Data, as format: DataFormat, source: String) throws -> ComicInfo.Issue {
  switch format {
  case .json:
    return try JSONDecoder().decode(ComicInfo.Issue.self, from: data)
  case .yaml:
    guard let yaml = String(data: data, encoding: .utf8) else { throw CLIError.notUTF8(source) }
    return try YAMLDecoder().decode(ComicInfo.Issue.self, from: yaml)
  case .xml:
    guard let xml = String(data: data, encoding: .utf8) else { throw CLIError.notUTF8(source) }
    return try ComicInfo.load(fromXML: xml)
  }
}

/// Serialize an Issue to the given format.
func serialize(_ issue: ComicInfo.Issue, as format: DataFormat) throws -> String {
  switch format {
  case .xml: return try issue.toXMLString()
  case .json: return try issue.toJSONString()
  case .yaml: return try issue.toYAMLString()
  }
}

/// Write a string to a file path, or to standard output when `path` is nil.
func writeOutput(_ content: String, to path: String?) throws {
  if let path {
    try content.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
  } else {
    print(content)
  }
}

// MARK: - Commands

struct Comicinfo: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "comicinfo",
    abstract: "\n  Read, validate, and convert ComicInfo.xml metadata",
    discussion: """
        Input can be: path/to/file
                      URL: http https file
                      XML string

      EXAMPLES:
        comicinfo read     ComicInfo.xml
        comicinfo read     https://example.com/ComicInfo.xml
        comicinfo validate ComicInfo.xml
        comicinfo convert  ComicInfo.xml --json       # JSON to stdout
        comicinfo convert  ComicInfo.xml comic.yml    # format from extension
        comicinfo convert  comic.yaml ComicInfo.xml   # YAML -> XML
      """,
    version: ComicInfo.Version.current,
    subcommands: [Read.self, Validate.self, Convert.self, Version.self]
  )
}

struct Read: ParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Display comic information")

  @Argument(help: "Input: path/to/file, URL (http https file), or XML string")
  var input: String

  func run() throws {
    printSummary(try loadIssue(from: input))
  }
}

struct Validate: ParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Validate a ComicInfo source")

  @Argument(help: "Input: path/to/file, URL (http https file), or XML string")
  var input: String

  func run() throws {
    do {
      printValidation(try loadIssue(from: input))
    } catch {
      print("❌ Invalid ComicInfo file: \(error.localizedDescription)")
      throw ExitCode.failure
    }
  }
}

struct Convert: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "Convert ComicInfo format: XML JSON YAML",
    discussion: """
      Default output: prints to STDOUT

      File output format is
        inferred from extension: .xml .json .yaml .yml
        or from flag:            --format
        or from format aliases:  --xml --json --yaml --yml
        (flags override inferred extension)

      EXAMPLES:
        comicinfo convert ComicInfo.xml comic.json   # JSON format from extension
        comicinfo convert ComicInfo.xml --yaml       # to stdout as YAML
        comicinfo convert comic.yaml ComicInfo.xml   # from YAML to XML
      """)

  @Argument(help: "Input: path/to/file, URL (http https file), or XML string")
  var input: String

  @Argument(help: "Output: STDOUT (default) or file path")
  var output: String?

  @Option(name: .long, help: "Output format: xml json yaml")
  var format: DataFormat?

  @Flag(help: "Output format alias: --xml --json --yaml --yml")
  var formatFlag: FormatFlag?

  func run() throws {
    let outputFormat = try resolveOutputFormat()
    let issue = try loadIssue(from: input)
    let serialized = try serialize(issue, as: outputFormat)
    try writeOutput(serialized, to: output)

    if let output {
      print("Wrote \(outputFormat.rawValue.uppercased()) to \(output)")
    }
  }

  /// Resolve the output format from `--format`, a shorthand flag, or the output file extension.
  func resolveOutputFormat() throws -> DataFormat {
    if let format, let flag = formatFlag?.dataFormat, format != flag {
      throw ValidationError("Conflicting output formats: --format \(format.rawValue) and --\(flag.rawValue)")
    }
    if let explicit = format ?? formatFlag?.dataFormat {
      return explicit
    }
    if let output, let inferred = DataFormat(fileExtension: URL(fileURLWithPath: output).pathExtension) {
      return inferred
    }
    throw ValidationError(
      """
        No output format.
        Specify either file or format:
          file with known extension: .xml .json .yaml .yml
          flag: --format --xml --json --yaml --yml

        Examples:
          file:       ComicInfo.xml
          flag:       --format=yml
          flag alias: --json
      """
    )
  }
}

struct Version: ParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Show version information")

  func run() {
    print(ComicInfo.Version.current)
  }
}

// MARK: - Output helpers

func printSummary(_ issue: ComicInfo.Issue) {
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

func printValidation(_ issue: ComicInfo.Issue) {
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
}

Comicinfo.main()
