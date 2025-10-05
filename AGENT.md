# Agent

This document tracks the development process, decisions, and progress of porting the ComicInfo Ruby gem to a Swift package.

## Project Overview

- **Source**: Ruby gem `comicinfo-ruby` (complete) https://github.com/veganstraightedge/comicinfo
- **Target**: Swift package `ComicInfo-swift` (in development)
- **Approach**: Test-Driven Development (TDD) based on Ruby RSpec tests

## Development Guidelines

- **Swift Version**: 6.2+
- **Testing Framework**: Swift Testing (not XCTest)
- **Code Formatting**: `swift format`, use 2 spaces for level indentation
- **Development Process**: TDD
  - Write failing tests first (based on Ruby RSpec tests)
  - Use XML fixture files in `Tests/Fixtures/`, not inline XML strings
  - Make one test pass, commit
  - Repeat

## Architecture Analysis

### Ruby Gem Structure
```
lib/comicinfo/
├── comicinfo.rb # Main entry point and loader
├── enums.rb     # Enum definitions
├── errors.rb    # Custom error classes
├── issue.rb     # Main ComicInfo::Issue class
├── page.rb      # ComicInfo::Page class
└── version.rb   # Version constant
```

### Swift Package Structure (Planned)
```
Sources/ComicInfo/
├── ComicInfo.swift # Main entry point and loader
├── Enums.swift     # Enum definitions
├── Errors.swift    # Error types
├── Issue.swift     # Main ComicInfo.Issue class
├── Page.swift      # ComicInfo.Page class
└── Version.swift   # Version constant
```

## Key Ruby Features to Port

### Core Functionality
- [ ] XML parsing from file paths or strings
- [ ] Complete ComicInfo v2.0 schema support
- [ ] Custom error handling with detailed messages
- [ ] Enum validation and type coercion
- [ ] Multi-value field support (string and array access)
- [ ] Page object hierarchy with type checking

### Ruby-specific Features → Swift Equivalents
- `ComicInfo.load(path_or_xml)` → `ComicInfo.load(from:)` and `ComicInfo.load(fromXML:)`
- Ruby `attr_reader` → Swift computed properties
- Ruby arrays/strings for multi-values → Swift arrays with convenience string properties
- Ruby `?` methods (`manga?`, `right_to_left?`) → Swift `is` properties (`isManga`, `isRightToLeft`)
- Ruby blocks/each → Swift `forEach` and functional methods
- Ruby exception classes → Swift Error protocol conformance

## Test Strategy

### Test File Mapping

```ruby
spec/comic_info_spec.rb        → Tests/ComicInfoTests/ComicInfoTests.swift
spec/comic_info/issue_spec.rb  → Tests/ComicInfoTests/IssueTests.swift
spec/comic_info/page_spec.rb   → Tests/ComicInfoTests/PageTests.swift
spec/comic_info/enums_spec.rb  → Tests/ComicInfoTests/EnumsTests.swift
spec/comic_info/errors_spec.rb → Tests/ComicInfoTests/ErrorsTests.swift
```

### Fixture Files
- Copy XML fixtures from Ruby `spec/fixtures/` to Swift `Tests/Fixtures/`
- Maintain same file structure for consistency
- Add Swift-specific fixtures as needed

### Test Conversion Examples
```ruby
# Ruby RSpec
it 'loads a minimal ComicInfo.xml file' do
  comic = load_fixture 'valid_minimal.xml'
  expect(comic.title).to eq 'Minimal Comic'
end
```

```swift
// Swift Testing
@Test func testLoadsMinimalComicInfoFile() async throws {
  let comic = try loadFixture("valid_minimal.xml")
  #expect(comic.title == "Minimal Comic")
}
```

## Development Phases

### Phase 1: Foundation ✅
- [x] Create README.md
- [x] Create AGENT.md
- [x] Create TODO.md
- [x] Set up basic project structure
- [x] Copy fixture files

### Phase 2: Core Types
- [ ] Define error types (`ComicInfoError`)
- [ ] Define enums (`AgeRating`, `Manga`, `BlackAndWhite`, `PageType`)
- [ ] Create basic `ComicInfo.Issue` structure
- [ ] Create basic `ComicInfo.Page` structure

### Phase 3: XML Parsing
- [ ] Implement basic XML loading from string
- [ ] Implement file loading
- [ ] Add basic field parsing (title, series, number)
- [ ] Add comprehensive field parsing

### Phase 4: Advanced Features
- [ ] Multi-value field support
- [ ] Page array parsing
- [ ] Enum validation and error handling
- [ ] Type coercion and validation

### Phase 5: API Completeness
- [ ] Convenience methods (`isManga`, `isRightToLeft`, etc.)
- [ ] Page type filtering (`coverPages`, `storyPages`)
- [ ] Array access for multi-value fields
- [ ] Export functionality (JSON, YAML, ComicInfo.xml)

## Design Decisions

### Swift Naming Conventions
- Ruby snake_case → Swift camelCase
- Ruby `?` methods → Swift `is` prefix
- Ruby class methods → Swift static methods
- Ruby instance variables → Swift stored properties

### Error Handling
- Ruby exceptions → Swift `Error` protocol
- Maintain detailed error messages
- Use associated values for error context

### Type System
- Ruby dynamic typing → Swift strong typing with optionals
- Ruby string/array duality → Swift arrays with computed string properties
- Ruby truthiness → Swift explicit boolean checks

### XML Parsing
- Ruby Nokogiri → Swift Foundation XMLParser
- Document-based parsing for clarity
- Maintain Ruby's flexible loading API

## Progress Tracking

### Completed Features
- [x] Project setup with Swift 6.2
- [x] README.md documentation
- [x] AGENT.md development log

### Current Focus
- [x] TODO.md task tracking
- [x] Fixture file setup
- [ ] Basic error type definitions

### Next Steps
- [x] Create comprehensive TODO.md
- [x] Set up fixture files
- [ ] Start with basic error types
- [ ] Implement first failing test for minimal XML loading

## Notes and Decisions

### Swift 6.2 Features to Leverage
- Modern concurrency (async/await)
- Improved type inference
- Better error handling
- Swift Testing framework

### Testing Philosophy
- Test-first development
- One test at a time
- Commit after each passing test
- Use fixtures, not inline XML
- Match Ruby test coverage and behavior

### Performance Considerations
- Document-based XML parsing
- Efficient string/array conversions

## Resources

- [Swift Testing Documentation](https://developer.apple.com/documentation/testing)
- [Swift 6.2 Language Guide](https://docs.swift.org/swift-book/)
- [Foundation XMLParser](https://developer.apple.com/documentation/foundation/xmlparser)
- [ComicInfo Schema Specification](https://github.com/anansi-project/comicinfo)
- [Ruby Source Code](../comicinfo-rb/)
