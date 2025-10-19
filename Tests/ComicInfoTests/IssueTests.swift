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

  @Test func testLoadCompleteFixture() throws {
    let issue = try loadFixture("valid_complete")
    #expect(issue.title == "The Amazing Spider-Man")
    #expect(issue.series == "The Amazing Spider-Man")
    #expect(issue.count == 600)
    #expect(issue.volume == 3)
  }

  @Test func testSummaryAndNotesFields() throws {
    let issue = try loadFixture("valid_complete")
    #expect(issue.summary?.contains("radioactive spider") == true)
    #expect(issue.notes == "Scanned by ComicTagger v1.0")
  }

  @Test func testCreatorFields() throws {
    let issue = try loadFixture("valid_complete")
    #expect(issue.writer == "Dan Slott, Christos Gage")
    #expect(issue.penciller == "Ryan Ottley")
    #expect(issue.inker == "Cliff Rathburn")
    #expect(issue.colorist == "Laura Martin")
    #expect(issue.letterer == "Joe Caramagna")
    #expect(issue.coverArtist == "Ryan Ottley")
    #expect(issue.editor == "Nick Lowe")
    #expect(issue.translator == "John Smith")
  }

  @Test func testPublicationFields() throws {
    let issue = try loadFixture("valid_complete")
    #expect(issue.publisher == "Marvel Comics")
    #expect(issue.imprint == "Marvel")
    #expect(issue.format == "Digital")
    #expect(issue.languageISO == "en-US")
  }
}
