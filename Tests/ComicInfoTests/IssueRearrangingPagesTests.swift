import Foundation
import Testing

@testable import ComicInfo

struct IssueRearrangingPagesTests {
  private let issue = ComicInfo.Issue(
    pageCount: 3,
    title: "Saga",
    year: 2012,
    pages: [
      ComicInfo.Page(image: 0, type: .frontCover, imageSize: 100),
      ComicInfo.Page(image: 1, type: .story, bookmark: "Chapter 1"),
      ComicInfo.Page(image: 2, type: .backCover),
    ]
  )

  @Test func testSameOrderChangesNothing() {
    let result = issue.rearrangingPages([0, 1, 2])
    #expect(result.pages == issue.pages)
    #expect(result.pageCount == 3)
  }

  @Test func testReorderedPagesKeepTheirDetailsUnderNewIndexes() {
    let result = issue.rearrangingPages([2, 0, 1])
    #expect(result.pages.map(\.image) == [0, 1, 2])
    #expect(result.pages.map(\.type) == [.backCover, .frontCover, .story])
    #expect(result.pages[1].imageSize == 100)
    #expect(result.pages[2].bookmark == "Chapter 1")
    #expect(result.pageCount == 3)
  }

  @Test func testDeletedPagesAreDroppedAndTheRestRenumbered() {
    let result = issue.rearrangingPages([0, 2])
    #expect(result.pages.map(\.image) == [0, 1])
    #expect(result.pages.map(\.type) == [.frontCover, .backCover])
    #expect(result.pageCount == 2)
  }

  @Test func testAddedPagesGetADefaultEntry() {
    let result = issue.rearrangingPages([0, nil, 1, 2])
    #expect(result.pages.map(\.image) == [0, 1, 2, 3])
    #expect(result.pages.map(\.type) == [.frontCover, .story, .story, .backCover])
    #expect(result.pages[1] == ComicInfo.Page(image: 1))
    #expect(result.pageCount == 4)
  }

  @Test func testPagesWithoutAnEntryStayWithoutOne() {
    let sparse = ComicInfo.Issue(pages: [ComicInfo.Page(image: 0, type: .frontCover)])
    let result = sparse.rearrangingPages([1, 0, 2])
    #expect(result.pages == [ComicInfo.Page(image: 1, type: .frontCover)])
  }

  @Test func testIssueWithoutPageEntriesGetsNone() {
    let bare = ComicInfo.Issue(title: "Bare")
    let result = bare.rearrangingPages([1, nil, 0])
    #expect(result.pages.isEmpty)
    #expect(result.pageCount == nil)
  }

  @Test func testPageCountIsOnlyUpdatedWhenItWasSet() {
    let counted = ComicInfo.Issue(pageCount: 20)
    #expect(counted.rearrangingPages([0, 1]).pageCount == 2)
  }

  @Test func testEveryOtherFieldIsCarriedOver() throws {
    let complete = try loadFixture("valid_complete")
    let order: [Int?] = Array(0..<12)
    let result = complete.rearrangingPages(order)

    #expect(try sortedJSON(result) == sortedJSON(complete.withPageCount(12)))
  }

  private func sortedJSON(_ issue: ComicInfo.Issue) throws -> String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys]
    return String(decoding: try encoder.encode(issue), as: UTF8.self)
  }
}

extension ComicInfo.Issue {
  /// The same issue with a different `pageCount`, by round-tripping through JSON.
  fileprivate func withPageCount(_ pageCount: Int) throws -> ComicInfo.Issue {
    let data = try toJSONData()
    var object = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
    object["pageCount"] = pageCount
    return try JSONDecoder().decode(ComicInfo.Issue.self, from: JSONSerialization.data(withJSONObject: object))
  }
}
