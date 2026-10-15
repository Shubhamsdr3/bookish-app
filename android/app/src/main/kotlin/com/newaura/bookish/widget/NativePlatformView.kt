package com.newaura.bookish.widget

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.TextView
import io.flutter.plugin.platform.PlatformView

internal class NativePlatformView(
    context: Context?,
    id: Int,
    val creationParams: Map<String?, Any?>?
) : PlatformView {

    private val textView: TextView = TextView(context)

    init {
        textView.textSize = 72F
        textView.setBackgroundColor(Color.rgb(255, 255, 255))
        textView.text = "Rendered on a native Android view (id: $id)"
    }

    override fun getView() = textView

    override fun dispose() {
    }
}