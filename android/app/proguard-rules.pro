# R8 full mode removes no-arg constructors that are only used by reflection.
# Firebase discovers these registrars from the manifest and calls that constructor.
-keep class * implements com.google.firebase.components.ComponentRegistrar {
    void <init>();
}

# Deferred components make Flutter skip its own ProGuard file, while this
# release build still minifies. Without this, R8 strips FlutterPlugin
# implementations and the profile channel throws MissingPluginException.
# https://github.com/flutter/flutter/issues/154580
-if class * implements io.flutter.embedding.engine.plugins.FlutterPlugin
-keep,allowshrinking,allowobfuscation class <1>

-keep class com.newaura.bookish.widget.PlatformViewPlugin { *; }
-keep class com.newaura.bookish.widget.NativeViewFactory { *; }
-keep class com.newaura.bookish.widget.NativeViewFactory$* { *; }
-keep class com.newaura.bookish.profile.ProfileBridge { *; }
-keep class com.newaura.bookish.profile.ProfileBridge$* { *; }
-keep class com.newaura.bookish.profile.ProfilePlatformView { *; }
-keep class com.newaura.bookish.profile.ProfileScreenKt { *; }
