# Repository Guidelines

## Project Structure & Module Organization
- `Package.swift` defines the SwiftPM library `ExpandableText` with targets `ExpandableText` (product) and `ExpandableTextTests` (test suite).
- `Sources/ExpandableText/` hosts the SwiftUI view, modifiers, and helpers (`ExpandableText.swift`, `ExpandableText+Modifiers.swift`, `ViewSizeReader.swift`, `TruncationTextMask.swift`, `View+Overlay.swift`).
- `Tests/ExpandableTextTests/` uses swift-testing for component coverage; mirror new source files with matching test files where it improves clarity.

## Build, Test, and Development Commands
- `swift build` compiles the library for the active toolchain.
- `swift test` runs the swift-testing suite; add `--enable-code-coverage` when you need coverage data.
- `swift package resolve` refreshes dependencies after `Package.swift` updates.
- Xcode users can open the folder directly or run `swift package generate-xcodeproj` if a project file is required.

## Coding Style & Naming Conventions
- Swift 6 + SwiftUI; 4-space indentation, trim trailing whitespace, keep lines focused on a single idea.
- Public APIs should carry doc comments; group helpers with `// MARK:` where it clarifies intent.
- Types use UpperCamelCase; functions, vars, and modifiers use lowerCamelCase; prefer expressive names over abbreviations.
- Extend `ExpandableText` with value-semantic modifiers (copy, mutate, return) to match the existing pattern.
- Avoid introducing new dependencies; reuse the existing gradient masking and size-reading helpers when adding UI behavior.

## Testing Guidelines
- Tests live in `Tests/ExpandableTextTests`; use `@Test` from `import Testing` and tag UI/stateful checks with `@MainActor`.
- Name tests after the behavior (`testInitialState`, `testCustomization`); keep one expectation per concern.
- Run `swift test` before pushing; add coverage for new modifiers, accessibility, and truncation logic.

## Commit & Pull Request Guidelines
- Commit messages follow short, present-tense statements (`Adds tap gesture…`, `Improves button tappability`); keep under ~72 characters.
- Include relevant tests in the same commit as code changes.
- PRs should describe the change, note platforms impacted, list how you tested, and attach screenshots/gifs for UI updates (collapsed vs expanded).
- Link issues when applicable and call out breaking changes explicitly.

## Security & Configuration Tips
- Do not commit personal signing assets or DerivedData; keep secrets out of the repo.
- Prefer sample text/data over real user content in tests and previews.
