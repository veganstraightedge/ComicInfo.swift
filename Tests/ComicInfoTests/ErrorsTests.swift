import Testing

@testable import ComicInfo

struct ErrorsTests {

  @Test func testParseErrorExists() throws {
    // Test that we can create and throw a parseError
    let error = ComicInfoError.parseError("test")
    #expect(error == ComicInfoError.parseError("test"))
  }

  @Test func testFileErrorExists() throws {
    // Test that we can create and throw a fileError
    let error = ComicInfoError.fileError("test")
    #expect(error == ComicInfoError.fileError("test"))
  }

  @Test func testInvalidEnumErrorExists() throws {
    // Test that we can create and throw an invalidEnum error
    let validValues = ["Yes", "No", "Unknown"]
    let error = ComicInfoError.invalidEnum(field: "Manga", value: "Maybe", validValues: validValues)
    #expect(error == ComicInfoError.invalidEnum(field: "Manga", value: "Maybe", validValues: validValues))
  }

  @Test func testRangeErrorExists() throws {
    // Test that we can create and throw a rangeError
    let error = ComicInfoError.rangeError(field: "Year", value: "999", min: "1000", max: "9999")
    #expect(error == ComicInfoError.rangeError(field: "Year", value: "999", min: "1000", max: "9999"))
  }

  @Test func testTypeCoercionErrorExists() throws {
    // Test that we can create and throw a typeCoercionError
    let error = ComicInfoError.typeCoercionError(field: "Count", value: "not-a-number", expectedType: "Integer")
    #expect(error == ComicInfoError.typeCoercionError(field: "Count", value: "not-a-number", expectedType: "Integer"))
  }

  @Test func testSchemaErrorExists() throws {
    // Test that we can create and throw a schemaError
    let error = ComicInfoError.schemaError("test")
    #expect(error == ComicInfoError.schemaError("test"))
  }

  @Test func testMalformedXMLThrowsParseError() throws {
    let malformedXML = "<ComicInfo><Title>Test</ComicInfo>"

    do {
      _ = try ComicInfo.load(fromXML: malformedXML)
      #expect(Bool(false), "Expected parseError to be thrown")
    } catch let error as ComicInfoError {
      switch error {
      case .parseError(_):
        // Expected
        break
      default:
        #expect(Bool(false), "Expected parseError, got \(error)")
      }
    }
  }

  @Test func testEmptyXMLThrowsParseError() throws {
    let emptyXML = ""

    do {
      _ = try ComicInfo.load(fromXML: emptyXML)
      #expect(Bool(false), "Expected parseError to be thrown")
    } catch let error as ComicInfoError {
      switch error {
      case .parseError(_):
        // Expected
        break
      default:
        #expect(Bool(false), "Expected parseError, got \(error)")
      }
    }
  }

  @Test func testNilXMLThrowsParseError() throws {
    // Swift doesn't allow nil strings, but we test empty string instead
    let nilXML = ""

    do {
      _ = try ComicInfo.load(fromXML: nilXML)
      #expect(Bool(false), "Expected parseError to be thrown")
    } catch let error as ComicInfoError {
      switch error {
      case .parseError(_):
        // Expected
        break
      default:
        #expect(Bool(false), "Expected parseError, got \(error)")
      }
    }
  }
}
