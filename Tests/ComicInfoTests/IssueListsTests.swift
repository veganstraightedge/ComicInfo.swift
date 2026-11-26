import Foundation
import Testing

@testable import ComicInfo

struct IssueListsTests {
  private let issue = ComicInfo.Issue(series: "Saga", title: "Chapter One")

  @Test func testSettingAListJoinsItWithCommas() {
    let updated = issue.settingGenres(["Action", "Adventure"])
    #expect(updated.genreRawData == "Action, Adventure")
    #expect(updated.genres == ["Action", "Adventure"])
  }

  @Test func testEachListHasItsOwnSetter() {
    #expect(issue.settingCharacters(["Alana", "Marko"]).charactersRawData == "Alana, Marko")
    #expect(issue.settingGenres(["Sci-Fi"]).genreRawData == "Sci-Fi")
    #expect(issue.settingLocations(["Landfall", "Wreath"]).locationsRawData == "Landfall, Wreath")
    #expect(issue.settingTeams(["The Will"]).teamsRawData == "The Will")
  }

  @Test func testSettingAnEmptyListRemovesIt() {
    let issue = ComicInfo.Issue(genreRawData: "Action")
    #expect(issue.settingGenres([]).genreRawData == nil)
    #expect(issue.settingGenres(["", "  "]).genreRawData == nil)
  }

  @Test func testSettingAListTrimsAndDropsEmptiesAndRepeats() {
    let updated = issue.settingCharacters(["  Alana ", "", "Marko", "Alana"])
    #expect(updated.charactersRawData == "Alana, Marko")
  }

  @Test func testCommasInsideAValueBecomeSpaces() {
    #expect(issue.settingCharacters(["Peter Parker, Jr."]).charactersRawData == "Peter Parker Jr.")
    #expect(issue.settingCharacters(["a,b"]).characters == ["a b"])
  }

  @Test func testSettingAListChangesNothingElse() throws {
    let complete = try loadFixture("valid_complete")
    let updated = complete.settingGenres(complete.genres.reversed())

    #expect(updated.genres == complete.genres.reversed())
    let restored = updated.settingGenres(complete.genres)
    #expect(try restored.toXMLString() == complete.toXMLString())
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

  @Test func testSettingWebLinksJoinsThemWithSpaces() {
    let links = [" https://example.com", "", "https://example.org", "https://example.com"]
    #expect(issue.settingWebLinks(links).webRawData == "https://example.com https://example.org")
    #expect(issue.settingWebLinks([]).webRawData == nil)
  }

  @Test func testAWebLinkWithSpacesInItBecomesSeveral() {
    let updated = issue.settingWebLinks(["https://example.com https://example.org"])
    #expect(updated.webLinks == ["https://example.com", "https://example.org"])
  }

  @Test func testSettingAListLeavesTheIssueItWasCalledOnAsItWas() {
    _ = issue.settingTeams(["The Will"])
    #expect(issue.teamsRawData == nil)
  }
}
