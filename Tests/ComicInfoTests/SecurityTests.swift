import Foundation
import Testing

@testable import ComicInfo

struct SecurityTests {

  /// A crafted XML must not resolve an external entity (XXE) and leak local file contents.
  @Test func testXXEExternalEntityDoesNotLeakLocalFile() throws {
    let secret = "XXE-SECRET-\(UUID().uuidString)"
    let secretURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).txt")
    try secret.write(to: secretURL, atomically: true, encoding: .utf8)
    defer { try? FileManager.default.removeItem(at: secretURL) }

    let xml = """
      <?xml version="1.0"?>
      <!DOCTYPE ComicInfo [ <!ENTITY xxe SYSTEM "file://\(secretURL.path)"> ]>
      <ComicInfo><Title>&xxe;</Title><Series>probe</Series></ComicInfo>
      """

    // Parsing may succeed with an empty/placeholder Title or throw — either is fine.
    // What must NOT happen is the external file's contents appearing in a field.
    let issue = try? ComicInfo.load(fromXML: xml)
    #expect(issue?.title?.contains(secret) != true)
    #expect(issue?.title?.contains("XXE-SECRET") != true)
  }
}
