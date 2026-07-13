# Project Profile — AppIos

> Cached architecture profile. Reuse for orientation; confirm a specific file/symbol still exists before relying on it. Rebuild only when explicitly asked (`sr emit learn-project`).

## Overview
- **Type:** iOS app (learning / early scaffold stage).
- **Bundle ID:** `nerd.AppIos` · **Version:** 1.0
- **Purpose:** Personal Swift/SwiftUI learning project. `docs/` holds a Vietnamese-language Swift + SwiftUI tutorial series; the app source is mostly empty stubs waiting to be filled in.

## Stack
- **Language:** Swift 5.0
- **UI framework:** SwiftUI (`@main` App lifecycle, no Storyboards)
- **Deployment target:** iOS 26.5
- **Build system:** Xcode project (`AppIos.xcodeproj`), no SPM `Package.swift`, no third-party dependencies
- **Tests:** `AppIosTests/` (XCTest target)

## Intended architecture (per pack rules — not yet realized in code)
MVVM + SwiftUI: **View → ViewModel (`ObservableObject`) → Service/Repository → data source**.
Folder layout signals the intended layering:

| Folder | Intended role | Current state |
|---|---|---|
| `AppIos/` | App entry + root view | `AppIosApp.swift`, `ContentView.swift` (default template) |
| `Core/Authentication/` | Feature module (Model / ViewModel / View split) | minimal scaffold, compiles |
| `Components/` | Reusable SwiftUI components | `CustomButton` present |
| `Services/` | API + persistence layer | empty stubs |
| `Helpers/` | Constants, formatters, theme | `Colors` token namespace present |
| `Extensions/` | Swift/SwiftUI extensions | one helper present |
| `docs/` | Swift + SwiftUI learning docs (VI) | complete, the real content |

## File catalog

### App
- `AppIos/AppIosApp.swift` — `@main struct AppIosApp: App`, shows `ContentView()`. **Working.**
- `AppIos/ContentView.swift` — default "Hello, world!" template view. **Working.**

### Core/Authentication (feature module)
- `Models/AuthUser.swift` — `struct AuthUser: Identifiable, Codable, Equatable` (`id`, `email`, `displayName?`). Domain model. **Working.**
- `ViewModels/AuthViewModal.swift` — `@MainActor final class LoginViewModel: ObservableObject` with `@Published email` / `password`. **Working.** (Note: file name still misspells "Modal"; the type is `LoginViewModel`.)
- `Views/LoginView.swift` — `struct LoginView` with `@ObservedObject var viewModel: LoginViewModel`. Currently renders a placeholder `Text`, not yet wired into navigation. **Working.**

### Components
- `CustomButton.swift` — reusable `CustomButton: View` (`title`, `action`), `.borderedProminent` style. **Working.**
- `Untitled.swift` — empty placeholder.

### Services
- `APIService.swift` — empty stub (intended: URLSession networking).
- `LocalDatabase.swift` — empty stub (intended: SwiftData/CoreData persistence).

### Helpers
- `Constants.swift` — empty.
- `DateFormatter.swift` — empty.
- `Theme/Light.swift` — defines the `enum Colors` token namespace + `light` token. **Working.**
- `Theme/Dark.swift` — `extension Colors` adding `dark` and `appLabel` tokens (system colors). **Working.**

### Extensions
- `Extensions.swift` — `View.eraseToAnyView() -> AnyView`. **Working.** Only genuinely reusable helper so far.

### Docs (the substantive content — Vietnamese)
- `docs/README.md` + `docs/01..08-*.md` — SwiftUI components tutorial (Text, Button, TextField, Image, Stacks, List, Form Controls, State/Binding).
- `docs/swift/README.md` + `docs/swift/01..08-*.md` — Swift language tutorial (basics, optionals, collections, functions, closures, enums, struct/class/protocol, concurrency).

## Build status
- Compiles cleanly for iOS Simulator (`** BUILD SUCCEEDED **`). The four original compile blockers (SwiftfUI typo, `import S`, missing `LoginViewModel`, undefined `Colors`) have been resolved.

## Key flows
- **Navigation:** none yet — app launches straight into `ContentView`. `LoginView` is not wired in.
- **Data/Auth:** not implemented (services empty).
- **Design tokens:** intended in `Helpers/Theme/` but not functional.

## Next-step notes for future tasks
- Auth wiring: `LoginViewModel` (in `Core/Authentication/ViewModels/`) and `AuthUser` model exist but are not yet connected — flesh out the view model (validation, submit), map to `AuthUser`, back it with `APIService`, and wire `LoginView` into navigation from `AppIosApp` / `ContentView`.
- `Services/APIService.swift` and `LocalDatabase.swift` are still empty stubs — implement URLSession networking and SwiftData/CoreData persistence when needed.
- `CustomButton` is available as the reusable primary button; use `Colors` tokens for theming rather than hardcoding.
