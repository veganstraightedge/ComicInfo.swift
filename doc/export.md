# Export Functionality

## JSON Export

```swift
let comic = try ComicInfo.load(from: "ComicInfo.xml")

// Export to JSON string
let jsonString = try comic.toJSONString()
print(jsonString)

// Export to JSON data
let jsonData = try comic.toJSONData()
try jsonData.write(to: URL(fileURLWithPath: "output.json"))

// Round-trip: JSON -> Issue
let decoder = JSONDecoder()
let reimported = try decoder.decode(ComicInfo.comic.self, from: jsonData)
```

## XML Export

```swift
let comic = ComicInfo.Issue(
  title: "My Comic",
  series: "My Series",
  number: "1",
  year: 2023,
  writer: "John Doe"
)

// Export to XML string
let xmlString = try comic.toXMLString()
print(xmlString)

// Save to file
try xmlString.write(
  to: URL(fileURLWithPath: "ComicInfo.xml"),
  atomically: true,
  encoding: .utf8
)

// Round-trip: XML -> Issue -> XML
let reimported = try ComicInfo.load(fromXML: xmlString)
let xmlString2 = try reimported.toXMLString()
```
