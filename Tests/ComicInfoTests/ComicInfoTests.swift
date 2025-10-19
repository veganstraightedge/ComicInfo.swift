import Foundation
import Testing

@testable import ComicInfo

struct ComicInfoTests {

  @Test func testComicInfoExists() {
    #expect(ComicInfo.self != nil)
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
