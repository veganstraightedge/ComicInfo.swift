import Testing

@testable import ComicInfo

struct IssueTests {

  @Test func testIssueTitleProperty() throws {
    let issue = ComicInfo.Issue()
    _ = issue.title
  }

  @Test func testIssueSeriesAndNumberProperties() throws {
    let issue = ComicInfo.Issue()
    _ = issue.series
    _ = issue.number
  }

  @Test func testIssueLoadMethod() throws {
    let xml = "<ComicInfo><Title>Test</Title></ComicInfo>"
    let issue = try ComicInfo.Issue.load(fromXML: xml)
    #expect(issue.title == "Test")
  }
}
