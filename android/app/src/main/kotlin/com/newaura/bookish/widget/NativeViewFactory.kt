package com.newaura.bookish.widget

import android.content.Context
import android.util.Log
import com.newaura.bookish.profile.ProfilePlatformView
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class NativeViewFactory(
    private val viewType: String,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(
        context: Context,
        viewId: Int,
        args: Any?,
    ): PlatformView {
        val creationParams = args as Map<*, *>?
        return when (viewType) {
            HYBRID_VIEW_TYPE -> NativePlatformView(
                context,
                viewId,
                creationParams as Map<String?, Any?>?,
            )
            COMPOSE_VIEW_TYPE -> ComposePlatformView(
                context,
                viewId,
                creationParams as Map<String, Any>?,
            )
            PROFILE_VIEW_TYPE -> {
                Log.i("BookishProfile", "factory create profile viewId=$viewId")
                ProfilePlatformView(context)
            }
            else -> error("Unknown platform view type: $viewType")
        }
    }

    companion object {
        const val HYBRID_VIEW_TYPE: String = "hybrid-view-type"
        const val COMPOSE_VIEW_TYPE: String = "compose-view-type"
        const val PROFILE_VIEW_TYPE: String = "profile-compose-view"
    }
}
