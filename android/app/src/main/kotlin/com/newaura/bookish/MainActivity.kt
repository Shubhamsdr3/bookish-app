package com.newaura.bookish

import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import androidx.activity.result.contract.ActivityResultContracts
import androidx.lifecycle.setViewTreeLifecycleOwner
import androidx.lifecycle.setViewTreeViewModelStoreOwner
import androidx.savedstate.setViewTreeSavedStateRegistryOwner
import com.newaura.bookish.media.NativeImagePickerActivity
import com.newaura.bookish.widget.NativeImageBridge
import com.newaura.bookish.widget.PlatformViewPlugin
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterFragmentActivity() {

    private val imagePickerLauncher = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult(),
    ) { result ->
        if (result.resultCode != RESULT_OK) {
            NativeImageBridge.emitImagePaths(emptyList())
            return@registerForActivityResult
        }
        val data = result.data
        if (data == null) {
            NativeImageBridge.emitImagePaths(emptyList())
            return@registerForActivityResult
        }
        val paths: ArrayList<String>? =
            data.getStringArrayListExtra(NativeImagePickerActivity.EXTRA_PATHS)
        if (paths != null && paths.isNotEmpty()) {
            NativeImageBridge.emitImagePaths(paths)
            return@registerForActivityResult
        }
        val path: String? = data.getStringExtra(NativeImagePickerActivity.EXTRA_PATH)
        if (path.isNullOrEmpty()) {
            NativeImageBridge.emitImagePaths(emptyList())
            return@registerForActivityResult
        }
        NativeImageBridge.emitImagePaths(listOf(path))
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        NativeImageBridge.attachLaunchers(
            openGallery = { allowMultiple ->
                imagePickerLauncher.launch(
                    NativeImagePickerActivity.createIntent(
                        this,
                        NativeImagePickerActivity.MODE_GALLERY,
                        allowMultiple = allowMultiple,
                    ),
                )
            },
            openCamera = {
                imagePickerLauncher.launch(
                    NativeImagePickerActivity.createIntent(
                        this,
                        NativeImagePickerActivity.MODE_CAMERA,
                    ),
                )
            },
        )
        installComposeViewTreeOwners()
    }

    override fun onDestroy() {
        NativeImageBridge.detachLaunchers()
        super.onDestroy()
    }

    override fun onPostResume() {
        super.onPostResume()
        installComposeViewTreeOwners()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(PlatformViewPlugin())
    }

    private fun installComposeViewTreeOwners() {
        val flutterView: FlutterView = findFlutterView(window.decorView) ?: return
        flutterView.setViewTreeLifecycleOwner(this)
        flutterView.setViewTreeViewModelStoreOwner(this)
        flutterView.setViewTreeSavedStateRegistryOwner(this)
    }

    private fun findFlutterView(view: View): FlutterView? {
        if (view is FlutterView) {
            return view
        }
        if (view is ViewGroup) {
            for (index in 0 until view.childCount) {
                val child: FlutterView? = findFlutterView(view.getChildAt(index))
                if (child != null) {
                    return child
                }
            }
        }
        return null
    }
}
