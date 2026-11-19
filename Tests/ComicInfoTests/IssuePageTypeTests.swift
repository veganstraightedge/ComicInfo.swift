import Foundation
import Testing

@testable import ComicInfo

struct IssuePageTypeTests {
  private let issue = ComicInfo.Issue(
    pageCount: 4,
    title: "Saga",
    pages: [
      ComicInfo.Page(image: 0, type: .frontCover, imageSize: 100),
      ComicInfo.Page(image: 1, types: [.story, .preview], doublePage: true, bookmark: "Chapter 1"),
      ComicInfo.Page(image: 3, type: .backCover),
    ]
  )

  @Test func testPageTypeIsTheEntrysType() {
    #expect(issue.pageType(at: 0) == .frontCover)
    #expect(issue.pageType(at: 1) == .story)
    #expect(issue.pageType(at: 3) == .backCover)
  }

  @Test func testPageWithoutAnEntryIsAStoryPage() {
    #expect(issue.pageType(at: 2) == .story)
    #expect(ComicInfo.Issue().pageType(at: 0) == .story)
  }

  @Test func testSettingATypeChangesOnlyThatEntrysType() {
    let result = issue.settingPageType(.advertisement, at: 0)

    #expect(result.pageType(at: 0) == .advertisement)
    #expect(result.pages[0].imageSize == 100)
    #expect(Array(result.pages.dropFirst()) == Array(issue.pages.dropFirst()))
    #expect(result.title == "Saga")
    #expect(result.pageCount == 4)
  }

  @Test func testSettingATypeReplacesEveryTypeThePageHad() {
    let result = issue.settingPageType(.letters, at: 1)

    #expect(result.pages[1].types == [.letters])
    #expect(result.pages[1].doublePage)
    #expect(result.pages[1].bookmark == "Chapter 1")
  }

  @Test func testSettingATypeOnAPageWithoutAnEntryAddsOneInImageOrder() {
    let result = issue.settingPageType(.editorial, at: 2)

    #expect(result.pages.map(\.image) == [0, 1, 2, 3])
    #expect(result.pages[2] == ComicInfo.Page(image: 2, type: .editorial))
  }

  @Test func testSettingStoryOnAPageWithoutAnEntryAddsNothing() {
    #expect(issue.settingPageType(.story, at: 2).pages == issue.pages)
    #expect(ComicInfo.Issue().settingPageType(.story, at: 0).pages.isEmpty)
  }

  @Test func testSettingStoryOnAnEntryKeepsTheEntry() {
    let result = issue.settingPageType(.story, at: 0)

    #expect(result.pages[0] == ComicInfo.Page(image: 0, type: .story, imageSize: 100))
  }

  @Test func testSettingTheTypeAPageAlreadyHasChangesNothing() {
    #expect(issue.settingPageType(.frontCover, at: 0).pages == issue.pages)
  }

  @Test func testSetTypeSurvivesXML() throws {
    let result = issue.settingPageType(.editorial, at: 2)
    let reloaded = try ComicInfo.load(fromXML: result.toXMLString())

    #expect(reloaded.pageType(at: 2) == .editorial)
    #expect(reloaded.pageType(at: 0) == .frontCover)
  }
}
