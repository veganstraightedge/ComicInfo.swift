# Agent

This document describes the development process of the ComicInfo.swift package.

## Communication style

- Be terse, not verbose
- Say as little as possible
- Don't write a long summary at the end
- Do write a short one-line summary that for my git commit message

## Project Overview

- **Source**: Ruby gem `comicinfo` https://github.com/veganstraightedge/comicinfo
- **Target**: Swift package `ComicInfo.swift` (released; see `CHANGELOG.md`)
- **Approach**: Test-Driven Development (TDD) based on Ruby RSpec tests

## Development Guidelines

- **Swift Version**: 6.4+
- **Testing Framework**: Swift Testing (not XCTest)
- **Code Formatting**: `swift format`, use 2 spaces for level indentation
- **Scripts**: `script/{build,test,lint,format,run}`; `script/lint` is `swift format lint --strict` (warnings fail)
- **Development Process**: TDD
  - Write failing tests first (based on Ruby RSpec tests)
  - Use XML fixture files in `Tests/ComicInfoTests/Fixtures/`, not inline XML strings
  - Make one test pass, commit
  - Repeat

## Architecture Analysis

### Ruby Gem Structure
```
lib/
├── comicinfo.rb    # Main entry point and loader
└── comicinfo/
    ├── enums.rb    # Enum definitions
    ├── errors.rb   # Custom error classes
    ├── issue.rb    # Main ComicInfo::Issue class
    ├── page.rb     # ComicInfo::Page class
    └── version.rb  # Version constant
```

### Swift Package Structure
```
Sources/
├── ComicInfo/
│   ├── ComicInfo.swift # Namespace, main entry point and loader
│   ├── Enums.swift     # Enum definitions
│   ├── Errors.swift    # Error types (top-level `ComicInfoError`)
│   ├── Issue.swift     # ComicInfo.Issue struct
│   ├── Page.swift      # ComicInfo.Page struct
│   └── Version.swift   # Version constant
└── ComicInfoCLI/
    └── main.swift      # `comicinfo` command-line tool
```

## Ruby-specific Features → Swift Equivalents
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
```

Swift-only, with no gem spec file behind them: `EnumsTests.swift`, `ErrorsTests.swift`, `SecurityTests.swift`.

### Fixture Files
- XML fixtures come from the gem's `spec/fixtures/`, and live in `Tests/ComicInfoTests/Fixtures/`
- Each fixture is a folder holding a `ComicInfo.xml` (`valid_minimal/ComicInfo.xml`); the gem uses flat files (`valid_minimal.xml`)
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
  let comic = try loadFixture("valid_minimal")
  #expect(comic.title == "Minimal Comic")
}
```

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
- Issue is not a standalone type, it's part of ComicInfo `namespace`

**File Organization:**
- `ComicInfo.swift` declares the `ComicInfo` enum and its `load` entry points
- Each nested type lives in its own file, declared inside `extension ComicInfo { ... }` (`Issue.swift`, `Page.swift`, `Enums.swift`, `Version.swift`)
- The one top-level type besides the namespace is `ComicInfoError` (`Errors.swift`)

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

## Common Mistakes to Avoid

### DON'T
- ❌ Write implementation before tests
- ❌ Rename domain types to fix test collisions (`ComicIssue` instead of `Issue`)
- ❌ Use inline XML strings in tests (use fixtures)
- ❌ Commit without running `script/format` and `script/lint`
- ❌ Make multiple tests pass in one commit
- ❌ Declare nested types at the top level (put them in `extension ComicInfo { ... }`)
- ❌ Add all properties at once (do incrementally with tests)
- ❌ Skip the failing test step

### DO
- ✅ Write ONE failing test first
- ✅ Use fixture files for XML test data
- ✅ Nest types to match Ruby module structure
- ✅ Run `script/format` and `script/lint` before every commit
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

## Resources

- [Swift Testing Documentation](https://developer.apple.com/documentation/testing)
- [Swift 6.4 Language Guide](https://docs.swift.org/swift-book/)
- [Foundation XMLDocument](https://developer.apple.com/documentation/foundation/xmldocument)
- [ComicInfo Schema Specification](https://github.com/anansi-project/comicinfo)
- [Ruby Source Code](https://github.com/veganstraightedge/comicinfo)
