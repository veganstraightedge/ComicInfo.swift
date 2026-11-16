import Foundation
import Testing

@testable import ComicInfo

struct IssueFilenameTests {
  private let template = "{series} #{number} ({year})"

  @Test func testFillsInEveryToken() {
    let issue = ComicInfo.Issue(number: "1", publisher: "Image", series: "Saga", title: "Chapter One", volume: 2, year: 2012)
    #expect(issue.filename(template: template) == "Saga #1 (2012)")
    #expect(issue.filename(template: "{publisher} - {series} v{volume} - {title}") == "Image - Saga v2 - Chapter One")
  }

  @Test func testFixtureIssue() throws {
    let issue = try loadFixture("valid_complete")
    #expect(issue.filename(template: template) == "The Amazing Spider-Man #1 (2018)")
  }

  @Test func testMissingValuesLeaveNoEmptyDecoration() {
    #expect(ComicInfo.Issue(series: "Saga").filename(template: template) == "Saga")
    #expect(ComicInfo.Issue(number: "1", series: "Saga").filename(template: template) == "Saga #1")
    #expect(ComicInfo.Issue(series: "Saga", year: 2012).filename(template: template) == "Saga (2012)")
    #expect(ComicInfo.Issue(series: "Saga").filename(template: "{series} [{year}]") == "Saga")
  }

  @Test func testIssueWithNoValuesGivesAnEmptyName() {
    #expect(ComicInfo.Issue().filename(template: template).isEmpty)
  }

  @Test func testCharactersThatCannotBeInAFilenameAreReplaced() {
    let issue = ComicInfo.Issue(number: "1/2", series: "Batman: Year One")
    #expect(issue.filename(template: "{series} #{number}") == "Batman- Year One #1-2")
  }

  @Test func testWhitespaceIsCollapsedAndTrimmed() {
    let issue = ComicInfo.Issue(series: "  Saga ", title: "One")
    #expect(issue.filename(template: " {series}   {title} ") == "Saga One")
  }

  @Test func testUnknownTokensAndPlainTextAreLeftAlone() {
    let issue = ComicInfo.Issue(series: "Saga")
    #expect(issue.filename(template: "{series} {colour} scan") == "Saga {colour} scan")
  }

  @Test func testTokensAreListed() {
    #expect(ComicInfo.Issue.filenameTokens == ["number", "publisher", "series", "title", "volume", "year"])
  }
}
