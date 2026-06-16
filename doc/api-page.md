# ComicInfo.Page

Represents a single page in a comic.

## Properties

- `image: Int` - Page number/index
- `type: PageType` - Page type enum
- `doublePage: Bool` - Double-page spread flag
- `imageSize: Int` - File size in bytes
- `key: String` - Key/identifier
- `bookmark: String` - Bookmark text
- `imageWidth: Int` - Image width (-1 if unknown)
- `imageHeight: Int` - Image height (-1 if unknown)

## Computed Properties

- `isCover: Bool` - True if cover page type
- `isStory: Bool` - True if story page type
- `isDeleted: Bool` - True if deleted page type
- `isDoublePage: Bool` - Same as `doublePage`
- `isBookmarked: Bool` - True if bookmark is set
- `dimensions: (width: Int?, height: Int?)` - Optional dimensions
- `dimensionsAvailable: Bool` - True if both dimensions known
- `aspectRatio: Double?` - Width/height ratio if available
