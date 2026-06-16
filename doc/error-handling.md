# Error Handling

```swift
do {
  let comic = try ComicInfo.load(from: "ComicInfo.xml")
  print("Loaded: \(comic.title ?? "Unknown")")
} catch ComicInfoError.fileError(let message) {
  print("File error: \(message)")
} catch ComicInfoError.parseError(let message) {
  print("Parse error: \(message)")
} catch ComicInfoError.invalidEnum(let field, let value, let validValues) {
  print("Invalid \(field): '\(value)'. Valid values: \(validValues)")
} catch ComicInfoError.rangeError(let field, let value, let min, let max) {
  print("\(field) value '\(value)' out of range (\(min)..\(max))")
} catch {
  print("Other error: \(error)")
}
```
