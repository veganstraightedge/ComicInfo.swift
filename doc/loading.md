# Loading ComicInfo.xml Files

```swift
import ComicInfo

// Load from file path
let comic = try ComicInfo.load(from: "/path/to/ComicInfo.xml")

// Load from URL
let url = URL(fileURLWithPath: "/path/to/ComicInfo.xml")
let comic = try ComicInfo.load(from: url)

// Load asynchronously (Swift 6.3+)
let comic = try await ComicInfo.load(from: url)

// Load from XML string
let xmlString = """
<ComicInfo>
  <Title>Amazing Spider-Man</Title>
  <Series>Amazing Spider-Man</Series>
  <Number>1</Number>
  <Year>2023</Year>
</ComicInfo>
"""
let comic = try ComicInfo.load(fromXML: xmlString)
```
