# Native host bridge

**Version:** v1  
**Owner:** bookish-frontend (this repo)  
**Consumer:** bookish-android (sibling)

## Current

- Channel: `channel:com.bookish.app`
- Dart: `lib/util/native_method_handler.dart`

## Changing the contract

1. Update Dart (and Pigeon defs if introduced) in this repo.
2. Regenerate codegen in this repo.
3. Copy any generated Kotlin into `bookish-android`.
4. Bump version in this file and both READMEs.
