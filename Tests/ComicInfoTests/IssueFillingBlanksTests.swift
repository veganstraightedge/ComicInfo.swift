import Foundation
import Testing

@testable import ComicInfo

struct IssueFillingBlanksTests {
  @Test func testBlankFieldsAreFilledFromTheFoundIssue() throws {
    let found = try loadFixture("valid_complete")
    let filled = ComicInfo.Issue().fillingBlanks(from: found)
    #expect(try filled.toXMLString() == found.withPages([], pageCount: found.pageCount).toXMLString())
  }

  @Test func testFieldsAlreadySetAreKept() throws {
    let found = try loadFixture("valid_complete")
    let issue = ComicInfo.Issue(
      ageRating: .teen, charactersRawData: "Alana", communityRating: 4.5, number: "7", series: "Saga",
      writer: "Brian K. Vaughan", year: 2012)
    let filled = issue.fillingBlanks(from: found)

    #expect(filled.series == "Saga")
    #expect(filled.number == "7")
    #expect(filled.writer == "Brian K. Vaughan")
    #expect(filled.year == 2012)
    #expect(filled.ageRating == .teen)
    #expect(filled.communityRating == 4.5)
    #expect(filled.characters == ["Alana"])
    #expect(filled.title == found.title)
    #expect(filled.publisher == found.publisher)
  }

  @Test func testWhitespaceCountsAsBlank() {
    let issue = ComicInfo.Issue(series: "  ", title: "")
    let filled = issue.fillingBlanks(from: ComicInfo.Issue(series: "Saga", title: "Chapter One"))
    #expect(filled.series == "Saga")
    #expect(filled.title == "Chapter One")
  }

  @Test func testUnknownEnumsCountAsBlank() {
    let issue = ComicInfo.Issue(ageRating: .unknown, blackAndWhite: .unknown, manga: .unknown)
    let found = ComicInfo.Issue(ageRating: .teen, blackAndWhite: .no, manga: .yesAndRightToLeft)
    let filled = issue.fillingBlanks(from: found)
    #expect(filled.ageRating == .teen)
    #expect(filled.blackAndWhite == .no)
    #expect(filled.manga == .yesAndRightToLeft)
  }

  @Test func testPagesAreKept() throws {
    let issue = ComicInfo.Issue(pageCount: 3, pages: [ComicInfo.Page(image: 0, type: .frontCover)])
    let filled = issue.fillingBlanks(from: try loadFixture("valid_complete"))
    #expect(filled.pages == issue.pages)
    #expect(filled.pageCount == 3)
  }
}
