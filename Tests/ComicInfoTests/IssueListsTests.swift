import Foundation
import Testing

@testable import ComicInfo

struct IssueListsTests {
  @Test func testJoinsAListWithCommas() {
    #expect(ComicInfo.Issue.joinedList(["Action", "Adventure"]) == "Action, Adventure")
    #expect(ComicInfo.Issue.joinedList(["Saga"]) == "Saga")
  }

  @Test func testJoinedListIsNilWhenThereIsNothingToWrite() {
    #expect(ComicInfo.Issue.joinedList([]) == nil)
    #expect(ComicInfo.Issue.joinedList(["", "  "]) == nil)
  }

  @Test func testJoinedListTrimsAndDropsEmptiesAndDuplicates() {
    let joined = ComicInfo.Issue.joinedList(["  Action ", "", "Adventure", "Action"])
    #expect(joined == "Action, Adventure")
  }

  @Test func testJoinedListReplacesCommasInsideAValue() {
    #expect(ComicInfo.Issue.joinedList(["Peter Parker, Jr."]) == "Peter Parker Jr.")
    #expect(ComicInfo.Issue.joinedList(["a,b"]) == "a b")
  }

  @Test func testJoinedListReadsBackAsTheSameList() throws {
    let issue = try loadFixture("valid_complete")
    let joined = ComicInfo.Issue.joinedList(issue.genres)
    #expect(ComicInfo.Issue(genreRawData: joined).genres == issue.genres)
  }

  @Test func testWebLinksKeepEveryEntryAsText() {
    let issue = ComicInfo.Issue(webRawData: "https://example.com  not a url\nhttps://example.org")
    #expect(issue.webLinks == ["https://example.com", "not", "a", "url", "https://example.org"])
  }

  @Test func testWebLinksFromFixture() throws {
    let issue = try loadFixture("valid_complete")
    #expect(
      issue.webLinks == [
        "https://marvel.com/comics/issue/12345",
        "https://comicvine.gamespot.com/amazing-spider-man-1/4000-67890/",
      ])
  }

  @Test func testWebLinksAreEmptyWithoutWeb() {
    #expect(ComicInfo.Issue().webLinks.isEmpty)
    #expect(ComicInfo.Issue(webRawData: "   ").webLinks.isEmpty)
  }

  @Test func testJoinsWebLinksWithSpaces() {
    let joined = ComicInfo.Issue.joinedWeb([" https://example.com", "", "https://example.org", "https://example.com"])
    #expect(joined == "https://example.com https://example.org")
    #expect(ComicInfo.Issue.joinedWeb([]) == nil)
  }

  @Test func testJoinedWebSplitsAnEntryWithSpacesInIt() {
    #expect(
      ComicInfo.Issue.joinedWeb(["https://example.com https://example.org"]) == "https://example.com https://example.org")
  }
}
