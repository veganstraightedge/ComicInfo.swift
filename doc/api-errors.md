# Error Types

All errors conform to `ComicInfoError` enum:

- `.fileError(String)` - File access errors
- `.parseError(String)` - XML parsing errors
- `.invalidEnum(field:value:validValues:)` - Invalid enum values
- `.rangeError(field:value:min:max:)` - Numeric range violations
- `.typeCoercionError(field:value:expectedType:)` - Type conversion errors
- `.schemaError(String)` - Schema validation errors
