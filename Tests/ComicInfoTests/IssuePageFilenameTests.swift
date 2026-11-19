import Foundation
import Testing

@testable import ComicInfo

struct IssuePageFilenameTests {
  private let issue = ComicInfo.Issue(number: "7", series: "Saga", year: 2012)

  @Test func testFillsInThePageNumber() {
    #expect(issue.pageFilename(template: "page_{page:3}", page: 1, of: 22) == "page_001")
    #expect(issue.pageFilename(template: "page_{page:3}", page: 22, of: 22) == "page_022")
    #expect(issue.pageFilename(template: "{page:4}", page: 5, of: 22) == "0005")
  }

  @Test func testFillsInIssueTokensToo() {
    let name = issue.pageFilename(template: "{series}_{number:3}_{page:4}", page: 12, of: 22)
    #expect(name == "Saga_007_0012")
  }

  @Test func testFixtureIssue() throws {
    let issue = try loadFixture("valid_complete")
    let name = issue.pageFilename(template: "{series} #{number:3} p{page:3}", page: 2, of: 20)
    #expect(name == "The Amazing Spider-Man #001 p002")
  }

  @Test func testPageNumberIsAtLeastAsWideAsThePageCount() {
    #expect(issue.pageFilename(template: "page_{page}", page: 2, of: 9) == "page_2")
    #expect(issue.pageFilename(template: "page_{page}", page: 2, of: 10) == "page_02")
    #expect(issue.pageFilename(template: "page_{page:2}", page: 2, of: 150) == "page_002")
    #expect(issue.pageFilename(template: "page_{page:1}", page: 150, of: 150) == "page_150")
  }

  @Test func testTemplateWithoutAPageNumberGetsOneAppended() {
    #expect(issue.pageFilename(template: "{series}", page: 3, of: 22) == "Saga_03")
    #expect(issue.pageFilename(template: "scan", page: 3, of: 22) == "scan_03")
    #expect(issue.pageFilename(template: "{page:0}", page: 3, of: 22) == "{page-0}_03")
  }

  @Test func testEmptyNameIsJustThePageNumber() {
    #expect(issue.pageFilename(template: "", page: 3, of: 22) == "03")
    #expect(ComicInfo.Issue().pageFilename(template: "{series}", page: 3, of: 22) == "03")
  }

  @Test func testCharactersThatCannotBeInAFilenameAreReplaced() {
    let issue = ComicInfo.Issue(series: "Batman: Year One")
    #expect(issue.pageFilename(template: "{series}/{page:3}", page: 1, of: 9) == "Batman- Year One-001")
  }

  @Test func testPageFilenameTokensAddPageToTheFilenameTokens() {
    #expect(ComicInfo.Issue.pageFilenameTokens == ComicInfo.Issue.filenameTokens + ["page"])
  }
}
