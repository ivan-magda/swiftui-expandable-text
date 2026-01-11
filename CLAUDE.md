# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Test Commands

```bash
swift build          # Build the library
swift test           # Run tests (uses swift-testing framework)
swift test --enable-code-coverage  # Run tests with coverage
```

**Linting:** SwiftLint is enforced in CI with `--strict`. Configuration is in `.swiftlint.yml`.

## Architecture

This is a Swift Package Manager library providing a single SwiftUI component: `ExpandableText`.

### Core Components

- **`ExpandableText.swift`** - Main view struct with state management for expansion/truncation detection. Uses a hidden background text measurement pattern to compare intrinsic vs truncated sizes.
- **`ExpandableText+Modifiers.swift`** - Value-semantic modifiers (copy-mutate-return pattern) for customization.
- **`TruncationTextMask.swift`** - Gradient mask that creates the fade effect before the "more" button. Handles RTL layout.
- **`ViewSizeReader.swift`** - `PreferenceKey`-based helper for measuring view sizes.
- **`View+Overlay.swift`** - iOS 14/15 compatibility wrapper for overlay alignment.

### Truncation Detection Pattern

The view renders text twice: once visible (with line limit) and once hidden (unconstrained). By comparing their sizes via `readSize`, it determines if truncation occurred. This drives the `isTruncated` state that controls the "more" button visibility.

### Modifier Pattern

All modifiers follow SwiftUI's value-semantic pattern:
```swift
func modifier(_ value: T) -> Self {
    var copy = self
    copy.property = value
    return copy
}
```

## Code Style

- Swift 6, 4-space indentation
- Line length: 120 warning, 150 error
- Tests use `@Test` from `import Testing` with `@MainActor` for UI state
