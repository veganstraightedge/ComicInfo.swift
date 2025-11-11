import Foundation
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
    #expect(issue.genreRawData == "Superhero, Action, Adventure")
    #expect(issue.webRawData?.contains("marvel.com") == true)
  }

  @Test func testMultiValueAndStoryFields() throws {
    let issue = try loadFixture("valid_complete")
    #expect(issue.charactersRawData == "Spider-Man, Peter Parker, J. Jonah Jameson, Aunt May")
    #expect(issue.teamsRawData == "Avengers")
    #expect(issue.locationsRawData == "New York City, Manhattan, Queens")
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
    #expect(issue.blackAndWhite == .no)
    #expect(issue.manga == .no)
    #expect(issue.ageRating == .teen)
  }

  @Test func testCharactersArray() throws {
    // Test both raw data and array access for characters
    let issue = try loadFixture("valid_complete")

    // Test raw data (string) access
    #expect(issue.charactersRawData == "Spider-Man, Peter Parker, J. Jonah Jameson, Aunt May")

    // Test array access (split by comma, trimmed)
    let charactersArray = issue.characters
    #expect(charactersArray == ["Spider-Man", "Peter Parker", "J. Jonah Jameson", "Aunt May"])
  }

  @Test func testTeamsArray() throws {
    // Test both raw data and array access for teams
    let issue = try loadFixture("valid_complete")

    // Test raw data (string) access
    #expect(issue.teamsRawData == "Avengers")

    // Test array access (split by comma, trimmed)
    let teamsArray = issue.teams
    #expect(teamsArray == ["Avengers"])
  }

  @Test func testLocationsArray() throws {
    // Test both raw data and array access for locations
    let issue = try loadFixture("valid_complete")

    // Test raw data (string) access
    #expect(issue.locationsRawData == "New York City, Manhattan, Queens")

    // Test array access (split by comma, trimmed)
    let locationsArray = issue.locations
    #expect(locationsArray == ["New York City", "Manhattan", "Queens"])
  }

  @Test func testGenresArray() throws {
    // Test both raw data and array access for genres
    let issue = try loadFixture("valid_complete")

    // Test raw data (string) access
    #expect(issue.genreRawData == "Superhero, Action, Adventure")

    // Test array access (split by comma, trimmed)
    let genresArray = issue.genres
    #expect(genresArray == ["Superhero", "Action", "Adventure"])
  }

  @Test func testWebUrlsArray() throws {
    // Test both raw data and array access for web
    let issue = try loadFixture("valid_complete")

    // Test raw data (string) access
    #expect(
      issue.webRawData
        == "https://marvel.com/comics/issue/12345 https://comicvine.gamespot.com/amazing-spider-man-1/4000-67890/")

    // Test array access (split by whitespace, converted to URL)
    let webUrlsArray = issue.webUrls
    #expect(
      webUrlsArray == [
        URL(string: "https://marvel.com/comics/issue/12345")!,
        URL(string: "https://comicvine.gamespot.com/amazing-spider-man-1/4000-67890/")!,
      ])
  }

  @Test func testPagesArray() throws {
    // Test parsing of Pages element with Page objects
    let issue = try loadFixture("valid_complete")

    #expect(issue.pages.count == 12)
    #expect(issue.hasPages == true)

    // Test first page (cover)
    let firstPage = issue.pages[0]
    #expect(firstPage.image == 0)
    #expect(firstPage.type == .frontCover)
    #expect(firstPage.doublePage == false)
    #expect(firstPage.imageSize == 1_024_000)
    #expect(firstPage.imageWidth == 1600)
    #expect(firstPage.imageHeight == 2400)

    // Test double page spread
    let doublePage = issue.pages[3]
    #expect(doublePage.image == 3)
    #expect(doublePage.type == .story)
    #expect(doublePage.doublePage == true)
    #expect(doublePage.imageWidth == 3200)
  }

  @Test func testCoverPagesFilter() throws {
    // Test coverPages computed property
    let issue = try loadFixture("valid_complete")
    let coverPages = issue.coverPages

    #expect(coverPages.count == 3)  // Front, Inner, Back covers
    #expect(coverPages.allSatisfy { $0.isCover })
    #expect(coverPages[0].type == .frontCover)
    #expect(coverPages[1].type == .innerCover)
    #expect(coverPages[2].type == .backCover)
  }

  @Test func testStoryPagesFilter() throws {
    // Test storyPages computed property
    let issue = try loadFixture("valid_complete")
    let storyPages = issue.storyPages

    #expect(storyPages.count == 6)  // Pages 2, 3, 4, 5, 7, 8 are story pages
    #expect(storyPages.allSatisfy { $0.isStory })
  }

  @Test func testMinimalIssueHasNoPages() throws {
    // Test that minimal fixture has no pages
    let issue = try loadFixture("valid_minimal")

    #expect(issue.pages.isEmpty)
    #expect(issue.hasPages == false)
    #expect(issue.coverPages.isEmpty)
    #expect(issue.storyPages.isEmpty)
  }

  @Test func testIssueMangaHelpers() throws {
    // Test manga convenience methods
    let mangaIssue = ComicInfo.Issue(manga: .yes)
    let rightToLeftIssue = ComicInfo.Issue(manga: .yesAndRightToLeft)
    let nonMangaIssue = ComicInfo.Issue(manga: .no)
    let unknownMangaIssue = ComicInfo.Issue(manga: .unknown)

    #expect(mangaIssue.isManga == true)
    #expect(mangaIssue.isRightToLeft == false)

    #expect(rightToLeftIssue.isManga == true)
    #expect(rightToLeftIssue.isRightToLeft == true)

    #expect(nonMangaIssue.isManga == false)
    #expect(nonMangaIssue.isRightToLeft == false)

    #expect(unknownMangaIssue.isManga == false)
    #expect(unknownMangaIssue.isRightToLeft == false)
  }

  @Test func testIssueBlackAndWhiteHelper() throws {
    // Test black and white convenience method
    let blackAndWhiteIssue = ComicInfo.Issue(blackAndWhite: .yes)
    let colorIssue = ComicInfo.Issue(blackAndWhite: .no)
    let unknownIssue = ComicInfo.Issue(blackAndWhite: .unknown)

    #expect(blackAndWhiteIssue.isBlackAndWhite == true)
    #expect(colorIssue.isBlackAndWhite == false)
    #expect(unknownIssue.isBlackAndWhite == false)
  }

  @Test func testPublicationDate() throws {
    // Test publicationDate computed property
    let fullDateIssue = ComicInfo.Issue(day: 15, month: 3, year: 2018)
    let yearOnlyIssue = ComicInfo.Issue(year: 2020)
    let noDateIssue = ComicInfo.Issue()

    // Full date should create proper Date object
    let fullDate = fullDateIssue.publicationDate
    #expect(fullDate != nil)
    let components = Calendar.current.dateComponents([.year, .month, .day], from: fullDate!)
    #expect(components.year == 2018)
    #expect(components.month == 3)
    #expect(components.day == 15)

    // Year only should default month/day to 1
    let yearOnlyDate = yearOnlyIssue.publicationDate
    #expect(yearOnlyDate != nil)
    let yearComponents = Calendar.current.dateComponents([.year, .month, .day], from: yearOnlyDate!)
    #expect(yearComponents.year == 2020)
    #expect(yearComponents.month == 1)
    #expect(yearComponents.day == 1)

    // No date should return nil
    #expect(noDateIssue.publicationDate == nil)
  }

  @Test func testUnicodeStringHandling() throws {
    // Test that Unicode characters in all string fields are handled correctly
    let issue = try loadFixture("unicode_test")

    // Test Japanese, emoji, and special characters
    #expect(issue.title == "スパイダーマン 🕷️ Amazing Spider-Man")
    #expect(issue.series == "マーベル・コミック")
    #expect(issue.number == "１")
    #expect(issue.writer == "丹・スロット, Κριστός Γκέιτζ")
    #expect(issue.publisher == "マーベル・エンターテインメント")

    // Test multi-value fields with Unicode
    let characters = issue.characters
    #expect(characters.contains("スパイダーマン"))
    #expect(characters.contains("ピーター・パーカー"))
    #expect(characters.contains("Тётя Мэй"))
    #expect(characters.contains("جون جيمسون"))

    let locations = issue.locations
    #expect(locations.contains("ニューヨーク市"))
    #expect(locations.contains("マンハッタン"))
    #expect(locations.contains("Κουίνς"))
    #expect(locations.contains("المدينة العربية"))

    // Test special characters and diacriticals
    #expect(issue.notes?.contains("♥️") == true)
    #expect(issue.notes?.contains("åæøÅÆØ") == true)
    #expect(issue.notes?.contains("ñáéíóúü") == true)
    #expect(issue.notes?.contains("ßäöü") == true)
    #expect(issue.notes?.contains("čćžšđ") == true)
  }

  @Test func testEmptyAndWhitespaceValues() throws {
    // Test handling of empty strings, whitespace-only values, and trimming
    let issue = try loadFixture("empty_values")

    #expect(issue.title == "Empty Values Test")
    #expect(issue.series == nil)  // Empty string should be nil
    #expect(issue.number == nil)  // Whitespace-only should be nil
    #expect(issue.summary == nil)  // Tab-only should be nil
    #expect(issue.notes == nil)  // Empty should be nil
    #expect(issue.writer == "John Doe")  // Should be trimmed
    #expect(issue.publisher == nil)  // Empty should be nil

    // Multi-value fields should filter out empty entries and trim
    let genres = issue.genres
    #expect(genres == ["Action", "Adventure"])  // Empty entries filtered out

    let characters = issue.characters
    #expect(characters == ["Spider-Man", "Peter Parker"])  // Empty/whitespace entries filtered

    // Numeric fields - empty should be nil
    #expect(issue.month == nil)
    #expect(issue.day == nil)
    #expect(issue.count == nil)
    #expect(issue.volume == nil)

    // Web URLs should trim whitespace
    let webUrls = issue.webUrls
    #expect(webUrls.count == 1)
    #expect(webUrls[0].absoluteString == "https://example.com")
  }
}
