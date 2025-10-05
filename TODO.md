# TODO - ComicInfo Swift Package

This document tracks all tasks needed to complete the port from the Ruby gem to Swift.

## Phase 1: Foundation Setup ✅

- [x] Create README.md
- [x] Create AGENT.md
- [x] Create TODO.md
- [x] Copy fixture files from Ruby to Swift
- [x] Create Tests/Fixtures/ directory structure
- [ ] Set up basic project file organization

## Phase 2: Core Types and Errors

### Error Types
- [ ] Define `ComicInfoError` enum with associated values
  - [ ] `fileNotFound(String)`
  - [ ] `parseError(String)`
  - [ ] `invalidEnum(field: String, value: String, validValues: [String])`
  - [ ] `valueOutOfRange(field: String, value: Any, range: String)`
  - [ ] `typeCoercionError(String)`
- [ ] Add error descriptions and localized descriptions
- [ ] Test: Error creation and message formatting

### Enums
- [ ] Define `AgeRating` enum with all Ruby values
  - [ ] Add `CaseIterable` conformance
  - [ ] Add string conversion methods
  - [ ] Test: All enum cases and string conversions
- [ ] Define `Manga` enum (.unknown, .no, .yes, .yesAndRightToLeft)
  - [ ] Test: Enum cases and boolean helpers
- [ ] Define `BlackAndWhite` enum (.unknown, .no, .yes)
  - [ ] Test: Enum cases and boolean helpers
- [ ] Define `PageType` enum (all page types from Ruby)
  - [ ] Add convenience boolean properties
  - [ ] Test: All page types and boolean checks

### Version
- [ ] Create Version.swift with version constant
- [ ] Test: Version number accessibility

## Phase 3: Basic XML Parsing and Issue Structure

### Issue Structure
- [ ] Create `ComicInfo.Issue` class/struct
- [ ] Add all basic string properties (title, series, number, etc.)
- [ ] Add all integer properties (count, volume, year, etc.)
- [ ] Add decimal properties (communityRating)
- [ ] Add enum properties (ageRating, manga, blackAndWhite)
- [ ] Test: Issue initialization with empty values

### Basic XML Loading
- [ ] Create main `ComicInfo` class with static methods
- [ ] Implement `load(from: String)` - file path loading
- [ ] Implement `load(from: URL)` - URL loading
- [ ] Implement `load(fromXML: String)` - XML string loading
- [ ] Implement `loadAsync(from: URL)` - async loading
- [ ] Test: Load minimal XML fixture
- [ ] Test: File not found error handling
- [ ] Test: Invalid XML error handling

### XML Parser Implementation
- [ ] Create XMLParser delegate for ComicInfo parsing
- [ ] Parse root ComicInfo element
- [ ] Parse all basic string elements
- [ ] Parse integer elements with type coercion
- [ ] Parse decimal elements with validation
- [ ] Parse enum elements with validation
- [ ] Test: Complete XML fixture parsing
- [ ] Test: Type coercion edge cases
- [ ] Test: Enum validation and error cases

## Phase 4: Advanced Features

### Multi-value Fields
- [ ] Add support for comma-separated string fields
- [ ] Create computed properties for array access:
  - [ ] `charactersArray` from `characters` string
  - [ ] `teamsArray` from `teams` string
  - [ ] `locationsArray` from `locations` string
  - [ ] `genresArray` from `genre` string
  - [ ] `webUrlsArray` from `web` string (as URLs)
- [ ] Test: Multi-value string parsing and array conversion
- [ ] Test: URL parsing for web field

### Page Support
- [ ] Create `ComicInfo.Page` class/struct
- [ ] Add all page properties (image, type, doublePage, etc.)
- [ ] Add page type enum parsing
- [ ] Add boolean convenience methods
- [ ] Parse Pages XML element and create page array
- [ ] Test: Page creation and property access
- [ ] Test: Page type validation
- [ ] Test: Page boolean helpers

### Issue Convenience Methods
- [ ] Add boolean properties:
  - [ ] `isManga` (computed from manga enum)
  - [ ] `isRightToLeft` (computed from manga)
  - [ ] `isBlackAndWhite` (computed from blackAndWhite enum)
  - [ ] `hasPages` (computed from pages array)
- [ ] Add page filtering methods:
  - [ ] `coverPages` (filter pages by cover types)
  - [ ] `storyPages` (filter pages by story type)
- [ ] Test: All boolean properties
- [ ] Test: Page filtering methods

## Phase 5: Test Coverage Matching Ruby Gem

### Core Loading Tests (from comic_info_spec.rb)
- [ ] Test: Load minimal XML fixture
- [ ] Test: Load complete XML fixture with all fields
- [ ] Test: File not found error
- [ ] Test: Invalid XML error
- [ ] Test: Load from XML string
- [ ] Test: Empty/nil file handling

### Issue Property Tests (from issue_spec.rb)
- [ ] Test: All string property access
- [ ] Test: All integer property access
- [ ] Test: Decimal property validation and range
- [ ] Test: Enum property parsing and validation
- [ ] Test: Multi-value field string and array access
- [ ] Test: Boolean helper methods
- [ ] Test: Unicode and special character handling

### Page Tests (from page_spec.rb)
- [ ] Test: Page creation and property access
- [ ] Test: Page type enum validation
- [ ] Test: Page boolean helpers (isCover, isStory, etc.)
- [ ] Test: Double page detection
- [ ] Test: Bookmark and dimension parsing

### Error Handling Tests (from errors_spec.rb)
- [ ] Test: Each error type creation
- [ ] Test: Error message formatting
- [ ] Test: Error context preservation
- [ ] Test: Nested error handling

### Edge Cases Tests (from fixtures/edge_cases/)
- [ ] Test: Malformed XML handling
- [ ] Test: Missing required elements
- [ ] Test: Invalid enum values
- [ ] Test: Out of range numeric values
- [ ] Test: Empty and whitespace-only values
- [ ] Test: Very large page arrays
- [ ] Test: Unicode in all string fields

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

**Next Task**: Copy fixture files from Ruby gem to set up testing infrastructure.

## Notes

- Keep API compatibility with Ruby gem concepts while following Swift conventions
- Maintain test coverage parity with Ruby gem (156 test cases)
- Use Swift 6.2 features appropriately (concurrency, improved type system)
- Focus on performance and memory efficiency for mobile platforms
