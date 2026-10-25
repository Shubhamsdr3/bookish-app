package com.newaura.bookish.widget

import android.util.Log
import com.newaura.bookish.profile.ProfileBridge
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.platform.PlatformViewRegistry

class PlatformViewPlugin : FlutterPlugin {

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        NativeImageBridge.attach(binding.binaryMessenger)
        ProfileBridge.attachChannel(binding.binaryMessenger)
        val registry: PlatformViewRegistry = binding.platformViewRegistry
        registry.registerViewFactory(
            NativeViewFactory.HYBRID_VIEW_TYPE,
            NativeViewFactory(NativeViewFactory.HYBRID_VIEW_TYPE),
        )
        registry.registerViewFactory(
            NativeViewFactory.COMPOSE_VIEW_TYPE,
            NativeViewFactory(NativeViewFactory.COMPOSE_VIEW_TYPE),
        )
        registry.registerViewFactory(
            NativeViewFactory.PROFILE_VIEW_TYPE,
            NativeViewFactory(NativeViewFactory.PROFILE_VIEW_TYPE),
        )
        Log.i("BookishProfile", "registered profile-compose-view")
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        NativeImageBridge.detach()
        ProfileBridge.detachChannel()
    }
}
