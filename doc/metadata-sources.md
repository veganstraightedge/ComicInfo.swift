# Looking Up Details in Online Databases

`ComicInfo.MetadataSource` is how a comic's details are looked up in an online comics database. This package defines it, and each database has its own package that implements it.

## Looking up an issue

```swift
import ComicInfo

func lookUp(_ issue: ComicInfo.Issue, in source: some ComicInfo.MetadataSource) async throws -> ComicInfo.Issue? {
  // Some databases need more than a series and number to search, such as a year.
  if let missing = source.missingDetails(for: issue) {
    print(missing)
    return nil
  }

  // The issues that might be this one, best first.
  let matches = try await source.matches(for: issue)
  guard let chosen = matches.first else { return nil }  // usually a person picks

  // Everything the database knows, added to what the comic already has.
  let found = try await source.issue(for: chosen)
  return issue.fillingBlanks(from: found)
}
```

- `ComicInfo.Match` is one search result: the database's ID for the issue, a `heading` such as "Saga (2012) #1", `details` to tell matches apart, and the issue's page on the database's site.
- `matches.ranked(for: issue)` orders matches best first: a series named exactly as the issue's, then a cover dated in its year. Sources call it themselves.
- `issue.fillingBlanks(from: found)` keeps every field the comic already has and fills the blank ones. Pages are never changed.

## Credit

Every database asks that what is shown from it credits and links to it. Show `source.name`, linked to `source.homeURL`, wherever its data appears.

## Writing a source

Conform to `ComicInfo.MetadataSource`:

- `name` and `homeURL`: for the credit.
- `missingDetails(for:)`: a sentence saying what the issue still needs, or `nil`.
- `matches(for:)`: search, map each result to a `Match`, and return them `ranked(for:)` the issue.
- `issue(for:)`: fetch the match's issue and map everything known onto a `ComicInfo.Issue`. Leave unknown fields `nil`.
