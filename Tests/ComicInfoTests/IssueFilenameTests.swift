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

  @Test func testNumberCanBeZeroPaddedToAWidth() {
    let issue = ComicInfo.Issue(number: "1", series: "Saga", year: 2012)
    #expect(issue.filename(template: "{series} #{number:3} ({year})") == "Saga #001 (2012)")
    #expect(issue.filename(template: "{number:2}") == "01")
    #expect(issue.filename(template: "{number:1}") == "1")
    #expect(issue.filename(template: "{number} {number:4}") == "1 0001")
  }

  @Test func testPaddingOnlyTouchesTheLeadingWholeNumber() {
    #expect(ComicInfo.Issue(number: "1.5").filename(template: "{number:3}") == "001.5")
    #expect(ComicInfo.Issue(number: "12AU").filename(template: "{number:3}") == "012AU")
    #expect(ComicInfo.Issue(number: "1000").filename(template: "{number:3}") == "1000")
    #expect(ComicInfo.Issue(number: "Annual").filename(template: "{number:3}") == "Annual")
    #expect(ComicInfo.Issue(number: "1/2").filename(template: "{number:3}") == "001-2")
  }

  @Test func testMissingNumberWithAWidthIsLeftOut() {
    #expect(ComicInfo.Issue(series: "Saga").filename(template: "{series} #{number:3}") == "Saga")
  }

  @Test func testAWidthOnAnyOtherTokenIsLeftAlone() {
    let issue = ComicInfo.Issue(number: "1", volume: 2)
    #expect(issue.filename(template: "{volume:2}") == "{volume:2}")
    #expect(issue.filename(template: "{number:x}") == "{number:x}")
    #expect(issue.filename(template: "{number:}") == "{number:}")
  }

  @Test func testTokensAreListed() {
    #expect(ComicInfo.Issue.filenameTokens == ["number", "publisher", "series", "title", "volume", "year"])
  }
}
