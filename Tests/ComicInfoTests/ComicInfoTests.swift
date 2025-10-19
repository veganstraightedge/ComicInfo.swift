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
