# Creating Issues Programmatically

```swift
import ComicInfo

// Create a new comic issue
let comic = ComicInfo.Issue(
  ageRating: .teen,
  colorist: "Steve Oliff",
  charactersRawData: "Spider-Man, Peter Parker, Mary Jane Watson",
  communityRating: 4.5,
  count: 100,
  coverArtist: "Todd McFarlane",
  day: 15,
  genreRawData: "Superhero, Action, Adventure",
  inker: "Todd McFarlane",
  languageISO: "en",
  letterer: "Rick Parker",
  locationsRawData: "New York City, Manhattan",
  manga: .no,
  month: 8,
  notes: "First appearance of Venom",
  number: "300",
  pageCount: 22,
  penciller: "Todd McFarlane",
  publisher: "Marvel Comics",
  series: "The Amazing Spider-Man",
  summary: "Spider-Man faces his greatest challenge yet...",
  title: "The Amazing Spider-Man",
  volume: 1,
  writer: "David Michelinie",
  year: 1988,
  pages: [
    ComicInfo.Page(image: 0, type: .frontCover),
    ComicInfo.Page(image: 1, type: .story),
    ComicInfo.Page(image: 2, type: .story),
    // ... more pages
    ComicInfo.Page(image: 21, type: .backCover)
  ]
)

// Export to XML
let xml = try comic.toXMLString()
try xml.write(to: URL(fileURLWithPath: "ComicInfo.xml"),
              atomically: true, encoding: .utf8)
```
