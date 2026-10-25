package com.newaura.bookish.widget

import android.os.Handler
import android.os.Looper
import com.newaura.bookish.native.NativeImageFlutterApi
import com.newaura.bookish.native.NativeImageHostApi
import io.flutter.plugin.common.BinaryMessenger

/**
 * Pigeon host wiring for gallery/camera.
 * [com.newaura.bookish.MainActivity] supplies Activity launchers.
 */
object NativeImageBridge : NativeImageHostApi {

    private val mainHandler: Handler = Handler(Looper.getMainLooper())
    private var messenger: BinaryMessenger? = null
    private var flutterApi: NativeImageFlutterApi? = null
    private var openGalleryAction: ((Boolean) -> Unit)? = null
    private var openCameraAction: (() -> Unit)? = null

    fun attach(binaryMessenger: BinaryMessenger) {
        messenger = binaryMessenger
        flutterApi = NativeImageFlutterApi(binaryMessenger)
        NativeImageHostApi.setUp(binaryMessenger, this)
    }

    fun detach() {
        messenger?.let { binaryMessenger ->
            NativeImageHostApi.setUp(binaryMessenger, null)
        }
        messenger = null
        flutterApi = null
    }

    fun attachLaunchers(
        openGallery: (allowMultiple: Boolean) -> Unit,
        openCamera: () -> Unit,
    ) {
        openGalleryAction = openGallery
        openCameraAction = openCamera
    }

    fun detachLaunchers() {
        openGalleryAction = null
        openCameraAction = null
    }

    override fun openGallery(allowMultiple: Boolean) {
        openGalleryAction?.invoke(allowMultiple)
    }

    override fun openCamera() {
        openCameraAction?.invoke()
    }

    fun emitImagePaths(paths: List<String>) {
        mainHandler.post {
            flutterApi?.onImagesPicked(paths) { /* ignore callback result */ }
        }
    }
}
