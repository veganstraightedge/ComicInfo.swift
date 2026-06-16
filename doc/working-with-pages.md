# Working with Pages

```swift
let issue = try ComicInfo.load(from: "ComicInfo.xml")

// Check if issue has page information
if comic.hasPages {
  print("Total pages: \(comic.pages.count)")

  // Filter pages by type
  let coverPages = comic.coverPages
  let storyPages = comic.storyPages

  print("Cover pages: \(coverPages.count)")
  print("Story pages: \(storyPages.count)")

  // Access individual pages
  for page in comic.pages {
    print("Page \(page.image): \(page.type)")

    if page.isCover {
      print("  This is a cover page")
    }

    if page.isDoublePage {
      print("  Double-page spread")
    }

    if let (width, height) = page.dimensions,
      page.dimensionsAvailable {
      print("  Size: \(width)x\(height)")
      if let ratio = page.aspectRatio {
        print("  Aspect ratio: \(ratio)")
      }
    }
  }
}
```
