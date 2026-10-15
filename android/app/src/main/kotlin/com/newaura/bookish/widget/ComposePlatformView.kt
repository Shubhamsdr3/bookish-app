package com.newaura.bookish.widget

import android.content.Context
import android.view.View
import android.view.ViewGroup
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.compose.ui.unit.dp
import androidx.lifecycle.findViewTreeLifecycleOwner
import androidx.lifecycle.setViewTreeLifecycleOwner
import androidx.savedstate.findViewTreeSavedStateRegistryOwner
import androidx.savedstate.setViewTreeSavedStateRegistryOwner
import io.flutter.plugin.platform.PlatformView

/**
 * Compose's window recomposer resolves ViewTree owners from the window root
 * ([io.flutter.embedding.android.FlutterView]), not from this [ComposeView] alone.
 * [com.newaura.bookish.MainActivity] installs those owners on FlutterView.
 * Composition is deferred until attach so that lookup succeeds.
 */
class ComposePlatformView(
    context: Context,
    id: Int,
    creationParams: Map<String, Any>?,
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
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(
                        space = 12.dp,
                        alignment = Alignment.CenterVertically,
                    ),
                    horizontalAlignment = Alignment.CenterHorizontally,
                ) {
                    Button(onClick = { NativeImageBridge.openGallery() }) {
                        Text(text = "Open gallery")
                    }
                    Button(onClick = { NativeImageBridge.openCamera() }) {
                        Text(text = "Open camera")
                    }
                }
            }
            hasSetContent = true
        }
    }

    override fun dispose() {
        composeView.disposeComposition()
    }
}
