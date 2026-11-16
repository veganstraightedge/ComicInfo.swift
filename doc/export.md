# Export Functionality

## JSON Export

```swift
let issue = try ComicInfo.load(from: "ComicInfo.xml")

// Export to JSON string
let jsonString = try issue.toJSONString()
print(jsonString)

// Export to JSON data
let jsonData = try issue.toJSONData()
try jsonData.write(to: URL(fileURLWithPath: "output.json"))

// Round-trip: JSON -> Issue
let decoder = JSONDecoder()
let reimported = try decoder.decode(ComicInfo.Issue.self, from: jsonData)
```

## YAML Export

```swift
let issue = try ComicInfo.load(from: "ComicInfo.xml")

let yamlString = try issue.toYAMLString()
print(yamlString)
```

## XML Export

```swift
let issue = ComicInfo.Issue(
  number: "1",
  series: "My Series",
  title: "My Comic",
  writer: "John Doe",
  year: 2023
)

// Export to XML string
let xmlString = try issue.toXMLString()
print(xmlString)

// Save to file, creating intermediate directories as needed
try issue.save(to: "ComicInfo.xml")
try issue.save(to: URL(fileURLWithPath: "/path/to/ComicInfo.xml"))

// Round-trip: XML -> Issue -> XML
let reimported = try ComicInfo.load(fromXML: xmlString)
let xmlString2 = try reimported.toXMLString()
```
