import Testing

@testable import ComicInfo

struct EnumsTests {

  @Test func testMangaEnumExists() throws {
    // Test that Manga enum exists and can be created
    let manga = ComicInfo.Manga.unknown
    #expect(manga == ComicInfo.Manga.unknown)
  }

  @Test func testMangaEnumCases() throws {
    // Test all Manga enum cases exist
    let unknown = ComicInfo.Manga.unknown
    let no = ComicInfo.Manga.no
    let yes = ComicInfo.Manga.yes
    let yesAndRightToLeft = ComicInfo.Manga.yesAndRightToLeft

    #expect(unknown == ComicInfo.Manga.unknown)
    #expect(no == ComicInfo.Manga.no)
    #expect(yes == ComicInfo.Manga.yes)
    #expect(yesAndRightToLeft == ComicInfo.Manga.yesAndRightToLeft)
  }

  @Test func testMangaStringConversion() throws {
    // Test string conversion methods
    #expect(ComicInfo.Manga.unknown.stringValue == "Unknown")
    #expect(ComicInfo.Manga.no.stringValue == "No")
    #expect(ComicInfo.Manga.yes.stringValue == "Yes")
    #expect(ComicInfo.Manga.yesAndRightToLeft.stringValue == "YesAndRightToLeft")
  }

  @Test func testMangaFromString() throws {
    // Test creation from string
    #expect(ComicInfo.Manga.from(string: "Unknown") == .unknown)
    #expect(ComicInfo.Manga.from(string: "No") == .no)
    #expect(ComicInfo.Manga.from(string: "Yes") == .yes)
    #expect(ComicInfo.Manga.from(string: "YesAndRightToLeft") == .yesAndRightToLeft)
  }

  @Test func testMangaFromInvalidString() throws {
    // Test invalid string handling
    do {
      _ = try ComicInfo.Manga.validated(from: "Invalid")
      #expect(Bool(false), "Expected invalidEnum error")
    } catch let error as ComicInfoError {
      switch error {
      case .invalidEnum(let field, let value, let validValues):
        #expect(field == "Manga")
        #expect(value == "Invalid")
        #expect(validValues == ["Unknown", "No", "Yes", "YesAndRightToLeft"])
      default:
        #expect(Bool(false), "Expected invalidEnum error, got \(error)")
      }
    }
  }

  @Test func testMangaFromEmptyString() throws {
    // Test empty/nil string defaults to unknown
    #expect(ComicInfo.Manga.from(string: "") == .unknown)
    #expect(ComicInfo.Manga.from(string: nil) == .unknown)
  }

  @Test func testMangaBooleanHelpers() throws {
    // Test convenience boolean methods
    #expect(ComicInfo.Manga.yes.isManga == true)
    #expect(ComicInfo.Manga.yesAndRightToLeft.isManga == true)
    #expect(ComicInfo.Manga.no.isManga == false)
    #expect(ComicInfo.Manga.unknown.isManga == false)

    #expect(ComicInfo.Manga.yesAndRightToLeft.isRightToLeft == true)
    #expect(ComicInfo.Manga.yes.isRightToLeft == false)
    #expect(ComicInfo.Manga.no.isRightToLeft == false)
    #expect(ComicInfo.Manga.unknown.isRightToLeft == false)
  }

  @Test func testAgeRatingEnumExists() throws {
    // Test that AgeRating enum exists
    let rating = ComicInfo.AgeRating.unknown
    #expect(rating == ComicInfo.AgeRating.unknown)
  }

  @Test func testAgeRatingEnumCases() throws {
    // Test key AgeRating enum cases exist
    let unknown = ComicInfo.AgeRating.unknown
    let everyone = ComicInfo.AgeRating.everyone
    let teen = ComicInfo.AgeRating.teen
    let mature = ComicInfo.AgeRating.mature17Plus
    let adultsOnly = ComicInfo.AgeRating.adultsOnly18Plus

    #expect(unknown == ComicInfo.AgeRating.unknown)
    #expect(everyone == ComicInfo.AgeRating.everyone)
    #expect(teen == ComicInfo.AgeRating.teen)
    #expect(mature == ComicInfo.AgeRating.mature17Plus)
    #expect(adultsOnly == ComicInfo.AgeRating.adultsOnly18Plus)
  }

  @Test func testAgeRatingStringConversion() throws {
    // Test age rating string conversion
    #expect(ComicInfo.AgeRating.unknown.stringValue == "Unknown")
    #expect(ComicInfo.AgeRating.everyone.stringValue == "Everyone")
    #expect(ComicInfo.AgeRating.teen.stringValue == "Teen")
    #expect(ComicInfo.AgeRating.mature17Plus.stringValue == "Mature 17+")
    #expect(ComicInfo.AgeRating.adultsOnly18Plus.stringValue == "Adults Only 18+")
  }

  @Test func testBlackAndWhiteEnumExists() throws {
    // Test that BlackAndWhite enum exists
    let bw = ComicInfo.BlackAndWhite.unknown
    #expect(bw == ComicInfo.BlackAndWhite.unknown)
  }

  @Test func testBlackAndWhiteEnumCases() throws {
    // Test BlackAndWhite enum cases
    let unknown = ComicInfo.BlackAndWhite.unknown
    let no = ComicInfo.BlackAndWhite.no
    let yes = ComicInfo.BlackAndWhite.yes

    #expect(unknown == ComicInfo.BlackAndWhite.unknown)
    #expect(no == ComicInfo.BlackAndWhite.no)
    #expect(yes == ComicInfo.BlackAndWhite.yes)
  }

  @Test func testBlackAndWhiteStringConversion() throws {
    // Test BlackAndWhite string conversion
    #expect(ComicInfo.BlackAndWhite.unknown.stringValue == "Unknown")
    #expect(ComicInfo.BlackAndWhite.no.stringValue == "No")
    #expect(ComicInfo.BlackAndWhite.yes.stringValue == "Yes")
  }

  @Test func testBlackAndWhiteBooleanHelper() throws {
    // Test BlackAndWhite boolean helper
    #expect(ComicInfo.BlackAndWhite.yes.isBlackAndWhite == true)
    #expect(ComicInfo.BlackAndWhite.no.isBlackAndWhite == false)
    #expect(ComicInfo.BlackAndWhite.unknown.isBlackAndWhite == false)
  }

  @Test func testIssueEnumFieldParsing() throws {
    // Test that Issue properly parses enum fields
    let xml = """
      <ComicInfo>
        <Title>Test Comic</Title>
        <Manga>Yes</Manga>
        <BlackAndWhite>No</BlackAndWhite>
        <AgeRating>Teen</AgeRating>
      </ComicInfo>
      """

    let issue = try ComicInfo.Issue.load(fromXML: xml)
    #expect(issue.manga == .yes)
    #expect(issue.blackAndWhite == .no)
    #expect(issue.ageRating == .teen)
  }

  @Test func testIssueEnumFieldInvalidValue() throws {
    // Test that Issue throws proper error for invalid enum values
    let xml = """
      <ComicInfo>
        <Title>Test Comic</Title>
        <Manga>InvalidValue</Manga>
      </ComicInfo>
      """

    do {
      _ = try ComicInfo.Issue.load(fromXML: xml)
      #expect(Bool(false), "Expected invalidEnum error")
    } catch let error as ComicInfoError {
      switch error {
      case .invalidEnum(let field, let value, _):
        #expect(field == "Manga")
        #expect(value == "InvalidValue")
      default:
        #expect(Bool(false), "Expected invalidEnum error, got \(error)")
      }
    }
  }
}
