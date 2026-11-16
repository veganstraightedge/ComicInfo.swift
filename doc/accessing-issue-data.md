# Accessing Issue Data

```swift
let issue = try ComicInfo.load(from: "ComicInfo.xml")

// Basic properties
print("Title: \(issue.title ?? "Unknown")")
print("Series: \(issue.series ?? "Unknown")")
print("Issue #: \(issue.number ?? "Unknown")")
print("Year: \(issue.year ?? 0)")

// Creator information
print("Writer: \(issue.writer ?? "Unknown")")
print("Artist: \(issue.penciller ?? "Unknown")")
print("Publisher: \(issue.publisher ?? "Unknown")")

// Multi-value fields (comma-separated in XML)
let genres = issue.genres          // ["Action", "Adventure", "Superhero"]
let characters = issue.characters  // ["Spider-Man", "Peter Parker"]
let locations = issue.locations    // ["New York", "Manhattan"]

// Boolean helpers
if issue.isManga {
  print("This is a manga")
  if issue.isRightToLeft {
    print("Read right-to-left")
  }
}

if issue.isBlackAndWhite {
  print("Black and white comic")
}

// Publication date
if let publicationDate = issue.publicationDate {
  print("Published: \(publicationDate)")
}
```
