import Foundation
import Testing

@testable import ComicInfo

/// Checks that issues and pages can be handed across concurrency domains.
///
/// A `MetadataSource`'s async methods are called from the main actor, say. This compiles only when
/// the types are `Sendable`.
struct SendableTests {
  private func sendable<Value: Sendable>(_ value: Value) -> Value { value }

  @Test func testIssuesAndTheirPartsAreSendable() throws {
    let issue = sendable(try loadFixture("valid_complete"))
    #expect(sendable(issue.pages).count == issue.pages.count)
    #expect(sendable(issue.manga) == issue.manga)
    #expect(sendable(issue.ageRating) == issue.ageRating)
    #expect(sendable(issue.blackAndWhite) == issue.blackAndWhite)
    #expect(sendable(ComicInfo.PageType.story) == .story)
    #expect(sendable(ComicInfoError.schemaError("x")) == .schemaError("x"))
  }
}
