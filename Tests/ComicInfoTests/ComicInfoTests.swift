import Foundation
import Testing

@testable import ComicInfo

struct ComicInfoTests {

  @Test func testComicInfoExists() {
    // ComicInfo enum exists and can be referenced
    #expect(ComicInfo.self == ComicInfo.self)
  }

  @Test func testLoadMethodExists() throws {
    let xml = "<ComicInfo></ComicInfo>"
    _ = try ComicInfo.load(fromXML: xml)
  }

  @Test func testLoadParsesTitle() throws {
    let xml = "<ComicInfo><Title>Test Comic</Title></ComicInfo>"
    let issue = try ComicInfo.load(fromXML: xml)
    #expect(issue.title == "Test Comic")
  }

  @Test func testLoadMinimalFixture() throws {
    let issue = try loadFixture("valid_minimal")
    #expect(issue.title == "Minimal Comic")
    #expect(issue.series == "Test Series")
    #expect(issue.number == "1")
  }

  @Test func testLoadFromFilePathString() throws {
    // Test loading from a file path string
    let testBundle = Bundle.module
    guard
      let fixtureURL = testBundle.url(forResource: "ComicInfo", withExtension: "xml", subdirectory: "Fixtures/valid_minimal")
    else {
      throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Fixture not found"])
    }

    let issue = try ComicInfo.load(from: fixtureURL.path)
    #expect(issue.title == "Minimal Comic")
    #expect(issue.series == "Test Series")
  }

  @Test func testLoadFromInvalidFilePath() throws {
    // Test loading from non-existent file path
    do {
      _ = try ComicInfo.load(from: "/nonexistent/path/ComicInfo.xml")
      #expect(Bool(false), "Expected fileError to be thrown")
    } catch let error as ComicInfoError {
      switch error {
      case .fileError(_):
        // Expected
        break
      default:
        #expect(Bool(false), "Expected fileError, got \(error)")
      }
    }
  }

  @Test func testLoadDetectsXMLString() throws {
    // Test that load method can detect XML string vs file path
    let xml = "<ComicInfo><Title>Direct XML</Title></ComicInfo>"
    let issue = try ComicInfo.load(from: xml)
    #expect(issue.title == "Direct XML")
  }

  @Test func testLoadDetectsFilePath() throws {
    // Test that load method can detect file path vs XML string
    let testBundle = Bundle.module
    guard
      let fixtureURL = testBundle.url(forResource: "ComicInfo", withExtension: "xml", subdirectory: "Fixtures/valid_minimal")
    else {
      throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Fixture not found"])
    }

    let issue = try ComicInfo.load(from: fixtureURL.path)
    #expect(issue.title == "Minimal Comic")
  }

  @Test func testLoadFromInvalidXML() throws {
    // Test loading from malformed XML
    do {
      _ = try loadFixture("invalid_root_element")
      #expect(Bool(false), "Expected parseError to be thrown")
    } catch let error as ComicInfoError {
      switch error {
      case .parseError(_):
        // Expected
        break
      default:
        #expect(Bool(false), "Expected parseError, got \(error)")
      }
    }
  }

  @Test func testLoadFromInvalidEnum() throws {
    // Test loading from invalid enum value
    do {
      _ = try loadFixture("invalid_enum")
      #expect(Bool(false), "Expected invalidEnum error to be thrown")
    } catch let error as ComicInfoError {
      switch error {
      case .invalidEnum(let field, let value, _):
        #expect(field == "Manga")
        #expect(value == "InvalidValue")
        break
      default:
        #expect(Bool(false), "Expected invalidEnum, got \(error)")
      }
    }
  }

  @Test func testLoadFromInvalidRange() throws {
    // Test loading from out of range value
    do {
      _ = try loadFixture("invalid_range")
      #expect(Bool(false), "Expected rangeError to be thrown")
    } catch let error as ComicInfoError {
      switch error {
      case .rangeError(let field, let value, _, _):
        #expect(field == "CommunityRating")
        #expect(value == "5.1")
        break
      default:
        #expect(Bool(false), "Expected rangeError, got \(error)")
      }
    }
  }

  @Test func testLoadFromInvalidYear() throws {
    // Test loading from out of range value for Year
    do {
      _ = try loadFixture("invalid_year")
      #expect(Bool(false), "Expected rangeError to be thrown")
    } catch let error as ComicInfoError {
      switch error {
      case .rangeError(let field, let value, _, _):
        #expect(field == "Year")
        #expect(value == "999")
        break
      default:
        #expect(Bool(false), "Expected rangeError, got \(error)")
      }
    }
  }

  @Test func testLoadFromInvalidMonth() throws {
    // Test loading from out of range value for Month
    do {
      _ = try loadFixture("invalid_month")
      #expect(Bool(false), "Expected rangeError to be thrown")
    } catch let error as ComicInfoError {
      switch error {
      case .rangeError(let field, let value, _, _):
        #expect(field == "Month")
        #expect(value == "13")
        break
      default:
        #expect(Bool(false), "Expected rangeError, got \(error)")
      }
    }
  }

  @Test func testLoadFromInvalidDay() throws {
    // Test loading from out of range value for Day
    do {
      _ = try loadFixture("invalid_day")
      #expect(Bool(false), "Expected rangeError to be thrown")
    } catch let error as ComicInfoError {
      switch error {
      case .rangeError(let field, let value, _, _):
        #expect(field == "Day")
        #expect(value == "32")
        break
      default:
        #expect(Bool(false), "Expected rangeError, got \(error)")
      }
    }
  }

  @Test func testLoadFromInvalidType() throws {
    // Test loading from a value that cannot be coerced
    do {
      _ = try loadFixture("invalid_type")
      #expect(Bool(false), "Expected typeCoercionError to be thrown")
    } catch let error as ComicInfoError {
      switch error {
      case .typeCoercionError(let field, let value, let expectedType):
        #expect(field == "Day")
        #expect(value == "not a number")
        #expect(expectedType == "Int")
        break
      default:
        #expect(Bool(false), "Expected typeCoercionError, got \(error)")
      }
    }
  }

  @Test func testLoadFromURL() throws {
    // Test loading from a file URL
    let testBundle = Bundle.module
    guard
      let fixtureURL = testBundle.url(
        forResource: "ComicInfo",
        withExtension: "xml",
        subdirectory: "Fixtures/valid_minimal"
      )
    else {
      throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Fixture not found"])
    }

    let issue = try ComicInfo.load(from: fixtureURL)
    #expect(issue.title == "Minimal Comic")
  }

  @Test func testLoadFromInvalidURL() throws {
    // Test loading from non-existent URL
    let invalidURL = URL(fileURLWithPath: "/nonexistent/path/ComicInfo.xml")

    do {
      _ = try ComicInfo.load(from: invalidURL)
      #expect(Bool(false), "Expected fileError to be thrown")
    } catch let error as ComicInfoError {
      switch error {
      case .fileError(let message):
        #expect(message.contains("Failed to read from URL"))
        break
      default:
        #expect(Bool(false), "Expected fileError, got \(error)")
      }
    }
  }

  @Test func testVersionConstant() throws {
    // Test that ComicInfo.Version.current is accessible and has expected format
    #expect(!ComicInfo.Version.current.isEmpty)
    #expect(ComicInfo.Version.current.contains("."))
    #expect(ComicInfo.Version.current == "1.0.1")
  }

  @available(macOS 26, iOS 26, watchOS 26, tvOS 26, *)
  @Test func testLoadFromURLAsync() async throws {
    // Test async loading from a file URL
    let testBundle = Bundle.module
    guard
      let fixtureURL = testBundle.url(
        forResource: "ComicInfo",
        withExtension: "xml",
        subdirectory: "Fixtures/valid_minimal"
      )
    else {
      throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Fixture not found"])
    }

    let issue = try await ComicInfo.load(from: fixtureURL)
    #expect(issue.title == "Minimal Comic")
  }
}

// MARK: - Test Helpers

func loadFixture(_ name: String) throws -> ComicInfo.Issue {
  let testBundle = Bundle.module

  guard
    let fixtureURL = testBundle.url(
      forResource: "ComicInfo",
      withExtension: "xml",
      subdirectory: "Fixtures/\(name)"
    )
  else {
    throw NSError(
      domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Fixture \(name)/ComicInfo.xml not found"])
  }

  let xmlData = try Data(contentsOf: fixtureURL)
  guard let xmlString = String(data: xmlData, encoding: .utf8) else {
    throw NSError(domain: "TestError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not decode XML as UTF-8"])
  }

  return try ComicInfo.load(fromXML: xmlString)
}
