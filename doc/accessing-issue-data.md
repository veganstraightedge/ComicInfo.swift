# Accessing Issue Data

```swift
let issue = try ComicInfo.load(from: "ComicInfo.xml")

// Basic properties
print("Title: \(comic.title ?? "Unknown")")
print("Series: \(comic.series ?? "Unknown")")
print("Issue #: \(comic.number ?? "Unknown")")
print("Year: \(comic.year ?? 0)")

// Creator information
print("Writer: \(comic.writer ?? "Unknown")")
print("Artist: \(comic.penciller ?? "Unknown")")
print("Publisher: \(comic.publisher ?? "Unknown")")

// Multi-value fields (comma-separated in XML)
let genres = comic.genres          // ["Action", "Adventure", "Superhero"]
let characters = comic.characters  // ["Spider-Man", "Peter Parker"]
let locations = comic.locations    // ["New York", "Manhattan"]

// Boolean helpers
if comics.isManga {
  print("This is a manga")
  if comics.isRightToLeft {
    print("Read right-to-left")
  }
}

if comics.isBlackAndWhite {
  print("Black and white comic")
}

// Publication date
if let pubDate = comic.publicationDate {
  print("Published: \(pubDate)")
}
```
