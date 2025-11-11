# Agent

This document tracks the development process, decisions, and progress of porting the ComicInfo Ruby gem to a Swift package.


## Communication style
- Be terse, not verbose
- Say as little as possible
- Don't write a long summary at the end
- Do write a short one-line summary that for my git commit message

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

### Type Structure - CRITICAL
**Ruby:**
```ruby
module ComicInfo
  class Issue
  end
end
# Usage: ComicInfo::Issue.new
```

**Swift:**
```swift
public enum ComicInfo {
  public struct Issue {
  }
}
// Usage: ComicInfo.Issue()
```

**Why nested types:**
- Matches Ruby module structure exactly: `ComicInfo::Issue` → `ComicInfo.Issue`
- Solves `Testing.Issue` name collision naturally
- Issue is not a standalone type, it's part of ComicInfo namespace
- Swift doesn't support reopening types to add nested types (no extensions with nested types)
- Therefore: ALL nested types must be in the same file as parent

**File Organization:**
- `ComicInfo.swift` contains both `ComicInfo` enum AND nested `Issue` struct
- One concept per file rule ONLY applies to top-level types
- Nested types stay with their parent (Swift limitation)
- Can use extensions in separate files for methods, but NOT for adding new nested types

### Method Delegation Pattern
**Ruby:**
```ruby
ComicInfo.load(...) → Issue.load(...) → Issue.new(...)
```

**Swift:**
```swift
ComicInfo.load(fromXML:) → Issue.load(fromXML:) → Issue(...)
```

- Top-level convenience method delegates to nested type
- Parsing logic lives in the nested type
- Matches Ruby gem architecture exactly

### Error Handling
- Ruby exceptions → Swift `Error` protocol
- Maintain detailed error messages
- Use associated values for error context

### Type System
- Ruby dynamic typing → Swift strong typing with optionals
- Ruby string/array duality → Swift arrays with computed string properties
- Ruby truthiness → Swift explicit boolean checks

### XML Parsing
- Ruby Nokogiri → Swift Foundation XMLDocument
- Document-based parsing using XMLDocument
- Use `.flatMap { Int($0) }` for safe string-to-int conversion
- Maintain Ruby's flexible loading API

### Testing.Issue Name Collision
**Problem:** Swift Testing framework has a type called `Issue` (for test failures)
**Wrong Solution:** Rename our type to `ComicIssue` (changes the API)
**Wrong Solution:** Use type aliases everywhere (messy workaround)
**Correct Solution:** Nest `Issue` inside `ComicInfo` enum
- Creates fully qualified type: `ComicInfo.Issue`
- No collision because our type is namespaced
- Matches Ruby structure: `ComicInfo::Issue`
- Clean, idiomatic Swift

### Namespace Pattern
- Use caseless enum for pure namespaces (can't be instantiated)
- `public enum ComicInfo` not `public struct ComicInfo`
- Signals intent: "this is a namespace, not meant to be instantiated"
- Common pattern in Swift (e.g., CommandLine)

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

## Common Mistakes to Avoid

### DON'T
- ❌ Write implementation before tests
- ❌ Rename domain types to fix test collisions (`ComicIssue` instead of `Issue`)
- ❌ Use inline XML strings in tests (use fixtures)
- ❌ Commit without running `swift format`
- ❌ Make multiple tests pass in one commit
- ❌ Separate nested types into their own files (Swift won't allow it)
- ❌ Add all properties at once (do incrementally with tests)
- ❌ Skip the failing test step

### DO
- ✅ Write ONE failing test first
- ✅ Use fixture files for XML test data
- ✅ Nest types to match Ruby module structure
- ✅ Run `swift format` before every commit
- ✅ Keep commits small and focused
- ✅ Match Ruby gem API exactly
- ✅ Fix root causes, not symptoms
- ✅ Be disciplined about TDD process

## Swift-Specific Patterns

### Safe Type Conversion
```swift
// String to Int with nil on failure
let count = root?.elements(forName: "Count").first?.stringValue.flatMap { Int($0) }
```

### Optional Chaining for XML
```swift
let title = root?.elements(forName: "Title").first?.stringValue
```

### Caseless Enum for Namespaces
```swift
public enum ComicInfo {  // Can't instantiate
  static func load() { }
}
```

## Progress Tracking

### Completed ✅
- [x] Project structure and organization
- [x] Nested Issue inside ComicInfo enum
- [x] Issue.load(fromXML:) delegation pattern
- [x] Basic string fields (title, series, number, summary, notes)
- [x] Integer fields (count, volume)
- [x] Creator fields (writer, penciller, inker, colorist, letterer, coverArtist, editor, translator)
- [x] Test fixture loading helper
- [x] Swift format integration

### In Progress 🚧
- [ ] Remaining string fields (publisher, imprint, format, etc.)
- [ ] Date fields (year, month, day)
- [ ] Enum fields (ageRating, manga, blackAndWhite)
- [ ] Decimal fields (communityRating)
- [ ] Multi-value fields (characters, teams, locations, etc.)
- [ ] Page support
- [ ] Error handling (proper error types)

### Future 📋
- [ ] File loading (not just XML strings)
- [ ] Convenience methods (isManga, isRightToLeft, etc.)
- [ ] Page filtering methods
- [ ] Export functionality

## Resources

- [Swift Testing Documentation](https://developer.apple.com/documentation/testing)
- [Swift 6.2 Language Guide](https://docs.swift.org/swift-book/)
- [Foundation XMLParser](https://developer.apple.com/documentation/foundation/xmlparser)
- [ComicInfo Schema Specification](https://github.com/anansi-project/comicinfo)
- [Ruby Source Code](../comicinfo-rb/)
