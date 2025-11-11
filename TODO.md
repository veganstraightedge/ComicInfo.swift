# TODO - ComicInfo Swift Package

This document tracks all tasks needed to complete the port from the Ruby gem to Swift.

## Phase 1: Foundation Setup ✅

- [x] Create README.md
- [x] Create AGENT.md
- [x] Create TODO.md
- [x] Copy fixture files from Ruby to Swift
- [x] Create Tests/Fixtures/ directory structure
- [x] Set up basic project file organization


## Phase 2: Test Coverage Matching Ruby Gem

- [ ] TDD: Write failing tests that are marked as skipped, then we will write implemetation to code to make each test pass, one at a time

### Core Loading Tests (from comic_info_spec.rb)
- [x] Test: Load minimal XML fixture
- [x] Test: Load complete XML fixture with all fields
- [x] Test: File not found error
- [x] Test: Invalid XML error
- [x] Test: Load from XML string
- [x] Test: Empty/nil file handling

### Issue Property Tests (from issue_spec.rb)
- [x] Test: All string property access
- [x] Test: All integer property access
- [x] Test: Decimal property validation and range
- [x] Test: Enum property parsing and validation
- [x] Test: Multi-value field string and array access
- [x] Test: Boolean helper methods
- [x] Test: Unicode and special character handling

### Page Tests (from page_spec.rb)
- [x] Test: Page creation and property access
- [x] Test: Page type enum validation
- [x] Test: Page boolean helpers (isCover, isStory, etc.)
- [x] Test: Double page detection
- [x] Test: Bookmark and dimension parsing

### Error Handling Tests (from errors_spec.rb)
- [x] Test: Each error type creation
- [x] Test: Error message formatting
- [x] Test: Error context preservation
- [x] Test: Nested error handling

### Edge Cases Tests (from fixtures/edge_cases/)
- [x] Test: Malformed XML handling
- [ ] Test: Missing required elements
- [x] Test: Invalid enum values
- [x] Test: Out of range numeric values
- [x] Test: Empty and whitespace-only values
- [ ] Test: Very large page arrays
- [x] Test: Unicode in all string fields

## Phase 3: Core Types and Errors

### Error Types
- [x] Define `ComicInfoError` enum with associated values
  - [x] `fileError(String)` 
  - [x] `parseError(String)`
  - [x] `invalidEnum(field: String, value: String, validValues: [String])`
  - [x] `rangeError(field: String, value: String, min: String, max: String)`
  - [x] `typeCoercionError(String)`
  - [x] `schemaError(String)`
- [x] Add error descriptions and localized descriptions
- [x] Test: Error creation and message formatting

### Enums
- [x] Define `AgeRating` enum with all Ruby values
  - [x] Add `CaseIterable` conformance
  - [x] Add string conversion methods
  - [x] Test: All enum cases and string conversions
- [x] Define `Manga` enum (.unknown, .no, .yes, .yesAndRightToLeft)
  - [x] Test: Enum cases and boolean helpers
- [x] Define `BlackAndWhite` enum (.unknown, .no, .yes)
  - [x] Test: Enum cases and boolean helpers
- [x] Define `PageType` enum (all page types from Ruby)
  - [x] Add convenience boolean properties
  - [x] Test: All page types and boolean checks

### Version
- [x] Create Version.swift with version constant
- [x] Test: Version number accessibility

## Phase 4: Basic XML Parsing and Issue Structure

### Issue Structure
- [x] Create `ComicInfo.Issue` class/struct
- [x] Add all basic string properties (title, series, number, etc.)
- [x] Add all integer properties (count, volume, year, etc.)
- [x] Add decimal properties (communityRating)
- [x] Add enum properties (ageRating, manga, blackAndWhite)
- [x] Test: Issue initialization with empty values

### Basic XML Loading
- [x] Create main `ComicInfo` class with static methods
- [x] Implement `load(from: String)` - file path loading
- [x] Implement `load(from: URL)` - URL loading
- [x] Implement `load(fromXML: String)` - XML string loading
- [x] Implement `loadAsync(from: URL)` - async loading
- [x] Test: Load minimal XML fixture
- [x] Test: File not found error handling
- [x] Test: Invalid XML error handling

### XML Parser Implementation
- [x] Create XMLParser delegate for ComicInfo parsing
- [x] Parse root ComicInfo element
- [x] Parse all basic string elements
- [x] Parse integer elements with type coercion
- [x] Parse decimal elements with validation
- [x] Parse enum elements with validation
- [x] Test: Complete XML fixture parsing
- [x] Test: Type coercion edge cases
- [x] Test: Enum validation and error cases

## Phase 5: Advanced Features

### Multi-value Fields
- [x] Add support for comma-separated string fields
- [x] Create computed properties for array access:
  - [x] `characters` from `charactersRawData` string
  - [x] `teams` from `teamsRawData` string
  - [x] `locations` from `locationsRawData` string
  - [x] `genres` from `genreRawData` string
  - [x] `webUrls` from `webRawData` string (as URLs)
- [x] Test: Multi-value string parsing and array conversion
- [x] Test: URL parsing for web field

### Page Support
- [x] Create `ComicInfo.Page` class/struct
- [x] Add all page properties (image, type, doublePage, etc.)
- [x] Add page type enum parsing
- [x] Add boolean convenience methods
- [x] Parse Pages XML element and create page array
- [x] Test: Page creation and property access
- [x] Test: Page type validation
- [x] Test: Page boolean helpers

### Issue Convenience Methods
- [x] Add boolean properties:
  - [x] `isManga` (computed from manga enum)
  - [x] `isRightToLeft` (computed from manga)
  - [x] `isBlackAndWhite` (computed from blackAndWhite enum)
  - [x] `hasPages` (computed from pages array)
- [x] Add page filtering methods:
  - [x] `coverPages` (filter pages by cover types)
  - [x] `storyPages` (filter pages by story type)
- [x] Add `publicationDate` computed property
- [x] Test: All boolean properties
- [x] Test: Page filtering methods

## Phase 6: API Polish and Export

### API Completeness
- [ ] Review all Ruby public methods are ported
- [ ] Add missing convenience methods from Ruby gem
- [ ] Ensure Swift naming conventions are followed
- [ ] Add proper documentation comments
- [ ] Test: API surface area matches expected usage

### Export Features (Optional - Future)
- [ ] Add Codable conformance to Issue and Page
- [ ] Implement JSON export functionality
- [ ] Implement PropertyList export functionality
- [ ] Test: Export and re-import round trips

### Performance and Memory
- [ ] Profile XML parsing performance
- [ ] Optimize memory usage for large page arrays
- [ ] Add lazy loading for page arrays if needed
- [ ] Test: Performance with large XML files

## Phase 7: Documentation and Polish

### Documentation
- [ ] Add comprehensive code documentation
- [ ] Update README with final API examples
- [ ] Create migration guide from Ruby gem
- [ ] Add troubleshooting section

### Code Quality
- [ ] Run swift-format on all files
- [ ] Add SwiftLint configuration and fix issues
- [ ] Review and refactor for Swift best practices
- [ ] Ensure Swift 6.2 feature usage

### Final Testing
- [ ] Run all tests and ensure 100% pass rate
- [ ] Test on all supported platforms (macOS, iOS, Linux)
- [ ] Performance testing with large XML files
- [ ] Memory leak testing

## Development Process Reminders

- ✅ **Write failing test first**
- ✅ **Make test pass with minimal code**
- ✅ **Commit after each passing test**
- ✅ **Use fixture files, not inline XML**
- ✅ **Match Ruby behavior exactly**
- ✅ **One feature at a time**

## Current Priority

**Next Task**: Complete remaining edge case tests and API polish features.

## Notes

- Keep API compatibility with Ruby gem concepts while following Swift conventions
- Maintain test coverage parity with Ruby gem (156 test cases)
- Use Swift 6.2 features appropriately (concurrency, improved type system)
- Focus on performance and memory efficiency for mobile platforms
