import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'bookish',
    dartOut: 'lib/native/generated/native_image_api.g.dart',
    kotlinOut:
        'android/app/src/main/kotlin/com/newaura/bookish/native/NativeImageApi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.newaura.bookish.native',
    ),
  ),
)

/// Host (native) API — Flutter calls these to open pickers.
@HostApi()
abstract class NativeImageHostApi {
  void openGallery(bool allowMultiple);

  void openCamera();
}

/// Flutter API — native calls back with picked file paths.
@FlutterApi()
abstract class NativeImageFlutterApi {
  void onImagesPicked(List<String> paths);
}
