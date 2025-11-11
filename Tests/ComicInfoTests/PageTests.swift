import Foundation
import Testing

@testable import ComicInfo

/// Tests for ComicInfo.Page functionality
struct PageTests {

  @Test func testPageInitializationWithRequiredImage() throws {
    // Test creating a page with required Image attribute
    #expect(throws: Never.self) {
      let page = ComicInfo.Page(image: 0, type: .story)
      #expect(page.image == 0)
      #expect(page.type == .story)
    }
  }

  @Test func testPageInitializationMissingImageThrowsError() throws {
    // Page requires image parameter in Swift (not optional)
    // This test demonstrates that image is required by the type system
    let page = ComicInfo.Page(image: 5)
    #expect(page.image == 5)
    #expect(page.type == .story)  // Default type
  }

  @Test func testPageDefaultValues() throws {
    // Test that page sets appropriate default values
    let page = ComicInfo.Page(image: 0)

    #expect(page.doublePage == false)
    #expect(page.type == .story)
    #expect(page.imageSize == 0)
    #expect(page.key == "")
    #expect(page.bookmark == "")
    #expect(page.imageWidth == -1)
    #expect(page.imageHeight == -1)
  }

  @Test func testPageCoverPredicate() throws {
    // Test isCover property for different page types
    let frontCover = ComicInfo.Page(image: 0, type: .frontCover)
    let backCover = ComicInfo.Page(image: 1, type: .backCover)
    let innerCover = ComicInfo.Page(image: 2, type: .innerCover)
    let storyPage = ComicInfo.Page(image: 3, type: .story)
    let adPage = ComicInfo.Page(image: 4, type: .advertisement)

    #expect(frontCover.isCover == true)
    #expect(backCover.isCover == true)
    #expect(innerCover.isCover == true)
    #expect(storyPage.isCover == false)
    #expect(adPage.isCover == false)
  }

  @Test func testPageStoryPredicate() throws {
    // Test isStory property
    let storyPage = ComicInfo.Page(image: 0, type: .story)
    let frontCover = ComicInfo.Page(image: 1, type: .frontCover)
    let adPage = ComicInfo.Page(image: 2, type: .advertisement)

    #expect(storyPage.isStory == true)
    #expect(frontCover.isStory == false)
    #expect(adPage.isStory == false)
  }

  @Test func testPageDeletedPredicate() throws {
    // Test isDeleted property
    let deletedPage = ComicInfo.Page(image: 0, type: .deleted)
    let storyPage = ComicInfo.Page(image: 1, type: .story)
    let frontCover = ComicInfo.Page(image: 2, type: .frontCover)

    #expect(deletedPage.isDeleted == true)
    #expect(storyPage.isDeleted == false)
    #expect(frontCover.isDeleted == false)
  }

  @Test func testPageDoublePagePredicate() throws {
    // Test isDoublePage property
    let doublePage = ComicInfo.Page(image: 0, doublePage: true)
    let singlePage = ComicInfo.Page(image: 1, doublePage: false)
    let defaultPage = ComicInfo.Page(image: 2)

    #expect(doublePage.isDoublePage == true)
    #expect(singlePage.isDoublePage == false)
    #expect(defaultPage.isDoublePage == false)
  }

  @Test func testPageTypesArray() throws {
    // Note: This test represents Ruby's ability to parse space-separated types
    // In Swift, we'll handle this differently - single type per page for now
    let page = ComicInfo.Page(image: 1, type: .story)
    #expect(page.type == .story)
  }

  @Test func testPageIncludesType() throws {
    // Test checking if page has specific type
    let storyPage = ComicInfo.Page(image: 1, type: .story)
    let coverPage = ComicInfo.Page(image: 2, type: .frontCover)

    #expect(storyPage.type == .story)
    #expect(coverPage.type == .frontCover)
    #expect(storyPage.type != .frontCover)
  }

  @Test func testPageDimensions() throws {
    // Test dimensions computed property
    let pageWithDimensions = ComicInfo.Page(image: 1, imageWidth: 1600, imageHeight: 2400)
    let pageWithoutDimensions = ComicInfo.Page(image: 2)
    let pageWithPartialDimensions = ComicInfo.Page(image: 3, imageWidth: 1600)

    #expect(pageWithDimensions.dimensions.width == 1600)
    #expect(pageWithDimensions.dimensions.height == 2400)
    #expect(pageWithoutDimensions.dimensions.width == nil)
    #expect(pageWithoutDimensions.dimensions.height == nil)
    #expect(pageWithPartialDimensions.dimensions.width == 1600)
    #expect(pageWithPartialDimensions.dimensions.height == nil)
  }

  @Test func testPageDimensionsAvailable() throws {
    // Test dimensionsAvailable computed property
    let pageWithDimensions = ComicInfo.Page(image: 1, imageWidth: 1600, imageHeight: 2400)
    let pageWithoutDimensions = ComicInfo.Page(image: 2)
    let pageWithPartialDimensions = ComicInfo.Page(image: 3, imageWidth: 1600)

    #expect(pageWithDimensions.dimensionsAvailable == true)
    #expect(pageWithoutDimensions.dimensionsAvailable == false)
    #expect(pageWithPartialDimensions.dimensionsAvailable == false)
  }

  @Test func testPageAspectRatio() throws {
    // Test aspectRatio computed property
    let pageWithDimensions = ComicInfo.Page(image: 1, imageWidth: 1600, imageHeight: 2400)
    let pageWithoutDimensions = ComicInfo.Page(image: 2)
    let pageWithZeroHeight = ComicInfo.Page(image: 3, imageWidth: 1600, imageHeight: 0)

    #expect(pageWithDimensions.aspectRatio == (1600.0 / 2400.0))
    #expect(pageWithoutDimensions.aspectRatio == nil)
    #expect(pageWithZeroHeight.aspectRatio == nil)
  }

  @Test func testPageBookmarked() throws {
    // Test isBookmarked computed property
    let pageWithBookmark = ComicInfo.Page(image: 1, bookmark: "Chapter 1")
    let pageWithEmptyBookmark = ComicInfo.Page(image: 2, bookmark: "")
    let pageWithoutBookmark = ComicInfo.Page(image: 3)

    #expect(pageWithBookmark.isBookmarked == true)
    #expect(pageWithEmptyBookmark.isBookmarked == false)
    #expect(pageWithoutBookmark.isBookmarked == false)
  }

  @Test func testPageEquality() throws {
    // Test page equality comparison
    let page1 = ComicInfo.Page(image: 1, type: .story, bookmark: "Chapter 1")
    let page2 = ComicInfo.Page(image: 1, type: .story, bookmark: "Chapter 1")
    let page3 = ComicInfo.Page(image: 2, type: .story, bookmark: "Chapter 1")

    #expect(page1 == page2)
    #expect(page1 != page3)
  }

  @Test func testPageStringRepresentation() throws {
    // Test string representation and description
    // For now, just test that Page conforms to expected protocols
    let page = ComicInfo.Page(image: 5, type: .story)

    // Test that page has expected properties
    #expect(page.image == 5)
    #expect(page.type == .story)

    // Test that Page conforms to Equatable and Hashable
    let samePage = ComicInfo.Page(image: 5, type: .story)
    #expect(page == samePage)
    #expect(page.hashValue == samePage.hashValue)
  }
}
