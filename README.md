# bookish-frontend

Bookish Flutter app. Dart package name: `bookish`.

## Run

```bash
cd bookish-frontend
flutter pub get
flutter run
```

`lib/main.dart` is the app entry, next to the root `pubspec.yaml`.

## Key routes (GetX)

| Route | Screen |
|-------|--------|
| `/home` | Home |
| `/createPost` | Create post |
| `/profile` | Profile |
| `/edit-profile` | Edit profile |

Exact names live in `lib/` screen `routeName` constants and `lib/app_routes.dart`.

## Native bridge

The method channel (`channel:com.bookish.app`) still lives in `lib/util/native_method_handler.dart`. See `BRIDGE.md`.

This repo is no longer an add-to-app Flutter module, so there is no `example/` host and no `.android/include_flutter.groovy` embed.
