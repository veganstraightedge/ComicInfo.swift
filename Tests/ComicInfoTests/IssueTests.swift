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

  @Test func testDateAndIntegerFields() throws {
    let issue = try loadFixture("valid_complete")
    #expect(issue.year == 2018)
    #expect(issue.month == 3)
    #expect(issue.day == 15)
    #expect(issue.alternateCount == 7)
    #expect(issue.pageCount == 20)
  }

  @Test func testRemainingStringFields() throws {
    let issue = try loadFixture("valid_complete")
    #expect(issue.alternateSeries == "Civil War")
    #expect(issue.alternateNumber == "2")
    #expect(issue.genre == "Superhero, Action, Adventure")
    #expect(issue.web?.contains("marvel.com") == true)
  }

  @Test func testMultiValueAndStoryFields() throws {
    let issue = try loadFixture("valid_complete")
    #expect(issue.characters == "Spider-Man, Peter Parker, J. Jonah Jameson, Aunt May")
    #expect(issue.teams == "Avengers")
    #expect(issue.locations == "New York City, Manhattan, Queens")
    #expect(issue.scanInformation == "Scanned at 300dpi, cleaned and leveled")
    #expect(issue.storyArc == "Brand New Day, Spider-Island")
    #expect(issue.storyArcNumber == "1, 5")
    #expect(issue.seriesGroup == "Spider-Man Family")
    #expect(issue.mainCharacterOrTeam == "Spider-Man")
  }

  @Test func testReviewAndRatingFields() throws {
    let issue = try loadFixture("valid_complete")
    #expect(issue.review?.contains("excellent start") == true)
    #expect(issue.communityRating == 4.25)
  }

  @Test func testEnumFields() throws {
    let issue = try loadFixture("valid_complete")
    #expect(issue.blackAndWhite == "No")
    #expect(issue.manga == "No")
    #expect(issue.ageRating == "Teen")
  }
}
