package com.newaura.bookish.profile

import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.lifecycle.findViewTreeLifecycleOwner
import androidx.lifecycle.setViewTreeLifecycleOwner
import androidx.savedstate.findViewTreeSavedStateRegistryOwner
import androidx.savedstate.setViewTreeSavedStateRegistryOwner
import com.newaura.bookish.ui.theme.BookishTheme
import io.flutter.plugin.platform.PlatformView

/**
 * Hosts [ProfileScreen] inside the Flutter bottom-nav Profile tab.
 * ViewTree owners come from FlutterView (installed by MainActivity).
 */
class ProfilePlatformView(
    context: Context,
) : PlatformView {

    private var hasSetContent: Boolean = false

    private val composeView: ComposeView = ComposeView(context).apply {
        layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT,
        )
        setViewCompositionStrategy(
            ViewCompositionStrategy.DisposeOnViewTreeLifecycleDestroyed,
        )
    }

    override fun getView(): View {
        return composeView
    }

    override fun onFlutterViewAttached(flutterView: View) {
        Log.i(
            TAG,
            "onFlutterViewAttached flutterView=${flutterView.width}x${flutterView.height}",
        )
        try {
            val lifecycleOwner = flutterView.findViewTreeLifecycleOwner()
                ?: error("FlutterView has no ViewTreeLifecycleOwner. MainActivity must install one.")
            val savedStateRegistryOwner = flutterView.findViewTreeSavedStateRegistryOwner()
                ?: error(
                    "FlutterView has no ViewTreeSavedStateRegistryOwner. MainActivity must install one.",
                )
            composeView.setViewTreeLifecycleOwner(lifecycleOwner)
            composeView.setViewTreeSavedStateRegistryOwner(savedStateRegistryOwner)
            if (!hasSetContent) {
                composeView.setContent {
                    BookishTheme {
                        ProfileScreen()
                    }
                }
                hasSetContent = true
                Log.i(TAG, "setContent done")
            }
        } catch (error: Throwable) {
            Log.e(TAG, "onFlutterViewAttached failed", error)
            throw error
        }
    }

    override fun dispose() {
        Log.i(TAG, "dispose")
        composeView.disposeComposition()
    }

    private companion object {
        const val TAG: String = "BookishProfile"
    }
}
