import Foundation
import Testing

@testable import ComicInfo

struct NumericFieldTests {

  @Test func testElementNamesMatchTheSchema() {
    #expect(ComicInfo.NumericField.alternateCount.elementName == "AlternateCount")
    #expect(ComicInfo.NumericField.communityRating.elementName == "CommunityRating")
    #expect(ComicInfo.NumericField.count.elementName == "Count")
    #expect(ComicInfo.NumericField.day.elementName == "Day")
    #expect(ComicInfo.NumericField.month.elementName == "Month")
    #expect(ComicInfo.NumericField.pageCount.elementName == "PageCount")
    #expect(ComicInfo.NumericField.volume.elementName == "Volume")
    #expect(ComicInfo.NumericField.year.elementName == "Year")
  }

  @Test func testBlankTextIsValidForEveryField() throws {
    for field in ComicInfo.NumericField.allCases {
      try field.validate("")
      try field.validate("  \n")
      #expect(try field.int(from: " ") == nil)
      #expect(try field.double(from: "") == nil)
    }
  }

  @Test func testValuesInRangeAreValid() throws {
    try ComicInfo.NumericField.alternateCount.validate("12")
    try ComicInfo.NumericField.communityRating.validate("0")
    try ComicInfo.NumericField.communityRating.validate("4.5")
    try ComicInfo.NumericField.communityRating.validate("5")
    try ComicInfo.NumericField.count.validate("6")
    try ComicInfo.NumericField.day.validate("1")
    try ComicInfo.NumericField.day.validate("31")
    try ComicInfo.NumericField.month.validate("12")
    try ComicInfo.NumericField.pageCount.validate("24")
    try ComicInfo.NumericField.volume.validate("2")
    try ComicInfo.NumericField.year.validate(" 1986 ")
  }

  @Test func testNonNumbersThrowTypeCoercionError() {
    #expect(throws: ComicInfoError.typeCoercionError(field: "Year", value: "abc", expectedType: "Int")) {
      try ComicInfo.NumericField.year.validate("abc")
    }
    #expect(throws: ComicInfoError.typeCoercionError(field: "PageCount", value: "2.5", expectedType: "Int")) {
      try ComicInfo.NumericField.pageCount.validate("2.5")
    }
    #expect(
      throws: ComicInfoError.typeCoercionError(field: "CommunityRating", value: "good", expectedType: "Double")
    ) {
      try ComicInfo.NumericField.communityRating.validate("good")
    }
  }

  @Test func testValuesOutOfRangeThrowRangeError() {
    #expect(throws: ComicInfoError.rangeError(field: "Year", value: "86", min: "1000", max: "9999")) {
      try ComicInfo.NumericField.year.validate("86")
    }
    #expect(throws: ComicInfoError.rangeError(field: "Month", value: "13", min: "1", max: "12")) {
      try ComicInfo.NumericField.month.validate("13")
    }
    #expect(throws: ComicInfoError.rangeError(field: "Month", value: "0", min: "1", max: "12")) {
      try ComicInfo.NumericField.month.validate("0")
    }
    #expect(throws: ComicInfoError.rangeError(field: "Day", value: "32", min: "1", max: "31")) {
      try ComicInfo.NumericField.day.validate("32")
    }
    #expect(throws: ComicInfoError.rangeError(field: "CommunityRating", value: "5.5", min: "0.0", max: "5.0")) {
      try ComicInfo.NumericField.communityRating.validate("5.5")
    }
  }

  @Test func testIntFromTextReturnsTheNumber() throws {
    #expect(try ComicInfo.NumericField.year.int(from: " 1986 ") == 1986)
    #expect(try ComicInfo.NumericField.count.int(from: "600") == 600)
    #expect(throws: ComicInfoError.rangeError(field: "Day", value: "40", min: "1", max: "31")) {
      try ComicInfo.NumericField.day.int(from: "40")
    }
  }

  @Test func testDoubleFromTextReturnsTheNumber() throws {
    #expect(try ComicInfo.NumericField.communityRating.double(from: "4.25") == 4.25)
    #expect(throws: ComicInfoError.rangeError(field: "CommunityRating", value: "-1", min: "0.0", max: "5.0")) {
      try ComicInfo.NumericField.communityRating.double(from: "-1")
    }
  }

  @Test func testBlankYearAndRatingElementsLoadAsNil() throws {
    let xml = "<ComicInfo><Year></Year><CommunityRating> </CommunityRating></ComicInfo>"
    let issue = try ComicInfo.load(fromXML: xml)
    #expect(issue.year == nil)
    #expect(issue.communityRating == nil)
  }
}
