# ComicInfo

The main namespace containing all types and loading methods.

## Static Methods

- `load(from: String)` - Smart load: a string starting with `<` is parsed as XML, anything else is read as a file path
- `load(from: URL)` - Load from file URL
- `load(from: URL) async` - Async load from a local or remote URL
- `load(fromXML: String)` - Load from XML string

## Version

- `ComicInfo.Version.current` - The package version string
