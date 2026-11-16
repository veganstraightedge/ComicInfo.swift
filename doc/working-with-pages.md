# Working with Pages

```swift
let issue = try ComicInfo.load(from: "ComicInfo.xml")

// Check if issue has page information
if issue.hasPages {
  print("Total pages: \(issue.pages.count)")

  // Filter pages by type
  let coverPages = issue.coverPages
  let storyPages = issue.storyPages

  print("Cover pages: \(coverPages.count)")
  print("Story pages: \(storyPages.count)")

  // Access individual pages
  for page in issue.pages {
    print("Page \(page.image): \(page.type)")

    if page.isCover {
      print("  This is a cover page")
    }

    if page.isDoublePage {
      print("  Double-page spread")
    }

    if let width = page.dimensions.width,
      let height = page.dimensions.height
    {
      print("  Size: \(width)x\(height)")
      if let ratio = page.aspectRatio {
        print("  Aspect ratio: \(ratio)")
      }
    }
  }
}
```

## Pages with more than one type

The schema lets a page carry several types. `types` holds all of them in order,
and `type` is the first one.

```swift
let page = ComicInfo.Page(image: 0, types: [.frontCover, .story])

page.type                       // .frontCover
page.types                      // [.frontCover, .story]
page.includesType(.story)       // true
page.isCover                    // true
page.isStory                    // true
```
