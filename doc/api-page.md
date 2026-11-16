# ComicInfo.Page

Represents a single page in a comic.

## Properties

- `image: Int` - Page number/index
- `types: [PageType]` - Page types, in order (defaults to `[.story]`)
- `doublePage: Bool` - Double-page spread flag
- `imageSize: Int` - File size in bytes (0 if unknown)
- `key: String` - Key/identifier
- `bookmark: String` - Bookmark text
- `imageWidth: Int` - Image width (-1 if unknown)
- `imageHeight: Int` - Image height (-1 if unknown)

## Computed Properties

- `type: PageType` - The first of `types`
- `isCover: Bool` - True if any type is a cover type
- `isStory: Bool` - True if any type is the story type
- `isDeleted: Bool` - True if any type is the deleted type
- `isDoublePage: Bool` - Same as `doublePage`
- `isBookmarked: Bool` - True if bookmark is set
- `dimensions: (width: Int?, height: Int?)` - Optional dimensions
- `dimensionsAvailable: Bool` - True if both dimensions known
- `aspectRatio: Double?` - Width/height ratio if available

## Methods

- `includesType(_: PageType) -> Bool` - True if the page carries the given type

## Initializers

- `init(image:types:doublePage:imageSize:key:bookmark:imageWidth:imageHeight:)` - Only `image` is required
- `init(image:type:doublePage:imageSize:key:bookmark:imageWidth:imageHeight:)` - Single-type convenience
