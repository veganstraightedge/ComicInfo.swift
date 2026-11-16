# Enums

## AgeRating

- `.unknown`
- `.adultsOnly18Plus`
- `.earlyChildhood`
- `.everyone`
- `.everyone10Plus`
- `.g`
- `.kidsToAdults`
- `.m`
- `.ma15Plus`
- `.mature17Plus`
- `.pg`
- `.r18Plus`
- `.ratingPending`
- `.teen`
- `.x18Plus`

## Manga

- `.unknown`
- `.no`
- `.yes`
- `.yesAndRightToLeft`

## BlackAndWhite

- `.unknown`
- `.no`
- `.yes`

## PageType

- `.frontCover`
- `.innerCover`
- `.roundup`
- `.story`
- `.advertisement`
- `.editorial`
- `.letters`
- `.preview`
- `.backCover`
- `.other`
- `.deleted`

## NumericField

The fields that hold a number, with the rules a value must meet. Blank text is always valid.

- `.alternateCount`, `.count`, `.pageCount`, `.volume` - any whole number
- `.day` - whole number, 1-31
- `.month` - whole number, 1-12
- `.year` - whole number, 1000-9999
- `.communityRating` - number, 0.0-5.0

Members:

- `elementName: String` - Schema element name, e.g. `AlternateCount`
- `validate(_: String) throws` - Throws `typeCoercionError` or `rangeError`
- `int(from: String) throws -> Int?` - The whole number, or nil for blank text
- `double(from: String) throws -> Double?` - The number, or nil for blank text

```swift
try ComicInfo.NumericField.year.validate("86")
// throws ComicInfoError.rangeError(field: "Year", value: "86", min: "1000", max: "9999")

let year = try ComicInfo.NumericField.year.int(from: "1986")  // 1986
```
