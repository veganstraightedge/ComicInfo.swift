import Foundation
import Testing

@testable import ComicInfo

struct IssueValidationTests {

  @Test func testValidIssuePassesValidation() throws {
    let issue = ComicInfo.Issue(communityRating: 4.5, count: 600, day: 31, month: 12, volume: 3, year: 1986)
    try issue.validate()
  }

  @Test func testEmptyIssuePassesValidation() throws {
    try ComicInfo.Issue().validate()
  }

  @Test func testFixtureIssuePassesValidation() throws {
    try loadFixture("valid_complete").validate()
  }

  @Test func testOutOfRangeValuesFailValidation() {
    #expect(throws: ComicInfoError.rangeError(field: "Year", value: "86", min: "1000", max: "9999")) {
      try ComicInfo.Issue(year: 86).validate()
    }
    #expect(throws: ComicInfoError.rangeError(field: "Month", value: "13", min: "1", max: "12")) {
      try ComicInfo.Issue(month: 13).validate()
    }
    #expect(throws: ComicInfoError.rangeError(field: "Day", value: "0", min: "1", max: "31")) {
      try ComicInfo.Issue(day: 0).validate()
    }
    #expect(throws: ComicInfoError.rangeError(field: "CommunityRating", value: "5.5", min: "0.0", max: "5.0")) {
      try ComicInfo.Issue(communityRating: 5.5).validate()
    }
  }

  @Test func testToXMLStringRefusesAnIssueItCouldNotLoadBack() {
    #expect(throws: ComicInfoError.rangeError(field: "Year", value: "86", min: "1000", max: "9999")) {
      try ComicInfo.Issue(year: 86).toXMLString()
    }
  }

  @Test func testSaveRefusesAnIssueItCouldNotLoadBack() throws {
    let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    defer { try? FileManager.default.removeItem(at: directory) }
    let url = directory.appendingPathComponent("ComicInfo.xml")

    #expect(throws: ComicInfoError.rangeError(field: "Month", value: "13", min: "1", max: "12")) {
      try ComicInfo.Issue(month: 13).save(to: url)
    }
    #expect(!FileManager.default.fileExists(atPath: url.path))
  }
}
