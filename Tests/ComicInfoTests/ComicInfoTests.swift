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

  @Test func testIssueTitleProperty() throws {
    let issue = Issue()
    _ = issue.title
  }

  @Test func testLoadParsesTitle() throws {
    let xml = "<ComicInfo><Title>Test Comic</Title></ComicInfo>"
    let issue = try ComicInfo.load(fromXML: xml)
    #expect(issue.title == "Test Comic")
  }

  @Test func testIssueSeriesAndNumberProperties() throws {
    let issue = Issue()
    _ = issue.series
    _ = issue.number
  }
}
