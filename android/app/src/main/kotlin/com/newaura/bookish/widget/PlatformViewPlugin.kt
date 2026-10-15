package com.newaura.bookish.widget

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.platform.PlatformViewRegistry

class PlatformViewPlugin : FlutterPlugin {

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        NativeImageBridge.attachChannel(binding.binaryMessenger)
        val registry: PlatformViewRegistry = binding.platformViewRegistry
        registry.registerViewFactory(
            NativeViewFactory.HYBRID_VIEW_TYPE,
            NativeViewFactory(NativeViewFactory.HYBRID_VIEW_TYPE),
        )
        registry.registerViewFactory(
            NativeViewFactory.COMPOSE_VIEW_TYPE,
            NativeViewFactory(NativeViewFactory.COMPOSE_VIEW_TYPE),
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        NativeImageBridge.detachChannel()
    }
}
