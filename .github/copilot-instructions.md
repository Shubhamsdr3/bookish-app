# Copilot instructions for Bookish

## Project overview

This repo is a Flutter/Dart app named `bookish` with a local path dependency on `network_service` for shared API/network behavior. The app entry is `lib/main.dart`; the root project config is in `pubspec.yaml`.

The codebase is a mixed architecture rather than a single strict pattern:

- `lib/main.dart` boots Firebase, app check, notification setup, permissions, and the app shell.
- `lib/app_routes.dart` defines the root `GetPage` routes and uses `Get.lazyPut(...)` for controller binding.
- Most legacy screens live under feature folders such as `lib/onboarding`, `lib/feed`, `lib/search`, `lib/topics`, `lib/home`, and `lib/profile` with controller/data/service layering.
- Some newer feature folders follow repository/use-case/provider patterns (`lib/createpost`, `lib/search`) while older screens still use `GetX` controllers and screen folders.
- `network_service/` is a sibling package that exposes the shared HTTP client, API config, and auth/network helpers.

The app also includes Android native integration under `android/app/src/main/kotlin/com/newaura/bookish/...` and iOS app config under `ios/`.

## Build, test, and lint commands

Use the Flutter toolchain from the repo root:

```bash
cd /Users/shubham.pandey/Documents/personal/bookish-frontend
flutter pub get
flutter run
```

Run a single test file or a single test by name:

```bash
flutter test test/api_service_test.dart
flutter test test/widget_test.dart
flutter test --plain-name "Counter increments smoke test" test/widget_test.dart
```

Lint/analyze the project:

```bash
flutter analyze
```

The repo currently has existing analyzer warnings in legacy files, so treat `flutter analyze` as the project lint command and avoid introducing new warnings in the files you touch.

## High-level architecture and code flow

- App startup (`lib/main.dart`): initializes Flutter bindings, Firebase, local notification setup, permissions, app check, and a shared API service before running the app shell.
- UI shell: `MyApp` wraps the app in `ProviderScope` and `ScreenUtilInit`, then boots a `GetMaterialApp` with `home: SplashScreen()`.
- Routing: `lib/app_routes.dart` centralizes all `GetPage` routes, including screen-specific bindings and dependency injection.
- Feature organization: each feature folder usually contains a mix of `controller`, `data`, `screen`, `domain`, and `ui` files. Keep feature-local responsibilities together instead of scattering them across unrelated folders.
- Networking: the app relies on the local `network_service` package, which is wired in through `pubspec.yaml` and initialized in `lib/main.dart` via `ApiService().initialize(...)`.
- Firebase and platform integrations: app config is in `lib/firebase_options.dart`; platform-specific Android/iOS code remains under the native folders and should be changed only when a platform feature requires it.

## Key conventions specific to this repo

- This repository intentionally mixes `GetX` and `Riverpod` patterns. Do not assume a single app-wide state-management convention; follow the existing pattern in the feature you are editing.
- Screen routes are established via `GetPage` names in `lib/app_routes.dart`; route names and controller bindings are not purely cosmetic and may be referenced by navigation calls elsewhere.
- Feature folders are mostly organized by domain (`feed`, `onboarding`, `topics`, `search`, etc.) rather than by technical layer alone. Match the surrounding structure when adding code.
- Firebase and app configuration are environment-sensitive. Do not hardcode secrets or environment values; use the existing config files and local environment patterns already in the project.
- `network_service` is a path dependency and may be the right place for shared API logic; avoid duplicating request logic in app screens when it belongs in the shared package.
- When editing Android code, keep changes aligned with the existing Kotlin views and platform channel setup in `android/app/src/main/kotlin/com/newaura/bookish/...`.

## Practical editing guidance

- Prefer small, feature-scoped changes that match the surrounding folder structure.
- When adding a new route or controller, update the route registration in `lib/app_routes.dart` and keep the route name consistent with the screen’s `routeName` constant.
- Preserve the repo’s mixed patterns; do not rewrite neighboring files to a different state-management system unless the task explicitly requires it.
- Use the existing app and feature names (`Bookish`, `HomeScreen`, `LoginScreen`, etc.) consistently so new code matches current conventions.
