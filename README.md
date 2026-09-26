# bookish-frontend

Flutter module for Bookish (add-to-app). This is the **primary** repo for day-to-day Flutter work.

Pub package name remains `bookish_module` so existing imports keep working.

## Layout

```
bookish-frontend/          # this repo (Flutter module)
  lib/
  network_service/
  example/                 # standalone host for flutter run
bookish-android/           # sibling repo (optional native host)
```

Clone as siblings under the same parent folder:

```bash
git clone git@github.com-personal:Shubhamsdr3/bookish-frontend.git
git clone git@github.com-personal:Shubhamsdr3/bookish-android.git
```

## Daily workflow (Flutter only)

```bash
cd bookish-frontend
flutter pub get
cd example
flutter pub get
flutter run
```

Or from the module root (ephemeral `.android` / `.ios` host):

```bash
cd bookish-frontend
flutter pub get
flutter run
```

## Embed in Android (`bookish-android`)

1. Clone `bookish-frontend` next to `bookish-android`.
2. From `bookish-frontend`, run `flutter pub get` so `.android/include_flutter.groovy` is generated.
3. Open `bookish-android` in Android Studio and sync.

The host points at:

`../bookish-frontend/.android/include_flutter.groovy`

## Host bridge (contract)

**Bridge version:** v1

Current bridge uses a `MethodChannel` (`channel:com.bookish.app`) via
`lib/util/native_method_handler.dart`.

If you introduce Pigeon later:

1. Keep the `.dart` API definition in this repo (single source of truth).
2. Regenerate Dart + Kotlin here.
3. Copy generated Kotlin into `bookish-android` (see that repo’s README).
4. Bump the bridge version note in both READMEs.

## Key routes (GetX)

| Route | Screen |
|-------|--------|
| `/home` | Home |
| `/createPost` | Create post |
| `/profile` | Profile |
| `/edit-profile` | Edit profile |

Exact names live in `lib/` screen `routeName` constants and `lib/app_routes.dart` when present.
