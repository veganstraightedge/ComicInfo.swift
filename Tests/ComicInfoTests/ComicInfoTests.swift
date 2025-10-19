import Testing
@testable import ComicInfo

struct ComicInfoTests {

  @Test func testComicInfoExists() {
    #expect(ComicInfo.self != nil)
  }

  @Test func testLoadMethodExists() throws {
    let xml = "<ComicInfo></ComicInfo>"
    _ = try ComicInfo.load(fromXML: xml)
  }

  @Test func testIssueTitleProperty() throws {
    let issue = Issue()
    _ = issue.title
  }
}
