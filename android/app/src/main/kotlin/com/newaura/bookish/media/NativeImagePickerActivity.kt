package com.newaura.bookish.media

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import java.io.File
import java.io.IOException

/**
 * Owns gallery/camera Activity Result contracts and returns local file path(s).
 * [com.newaura.bookish.MainActivity] starts this activity and forwards paths to Flutter via Pigeon.
 */
class NativeImagePickerActivity : ComponentActivity() {

    private var cameraPhotoFile: File? = null
    private var hasLaunchedPicker: Boolean = false
    private var allowMultiple: Boolean = false

    private val pickSingleMedia = registerForActivityResult(
        ActivityResultContracts.PickVisualMedia(),
    ) { uri: Uri? ->
        if (uri == null) {
            finishCanceled()
            return@registerForActivityResult
        }
        val path: String? = copyUriToCache(uri)
        if (path == null) {
            finishCanceled()
        } else {
            finishWithPaths(listOf(path))
        }
    }

    private val pickMultipleMedia = registerForActivityResult(
        ActivityResultContracts.PickMultipleVisualMedia(),
    ) { uris: List<Uri> ->
        if (uris.isEmpty()) {
            finishCanceled()
            return@registerForActivityResult
        }
        val paths: List<String> = uris.mapNotNull { uri -> copyUriToCache(uri) }
        if (paths.isEmpty()) {
            finishCanceled()
        } else {
            finishWithPaths(paths)
        }
    }

    private val takePicture = registerForActivityResult(
        ActivityResultContracts.TakePicture(),
    ) { success: Boolean ->
        val path: String? = cameraPhotoFile?.absolutePath
        if (success && path != null) {
            finishWithPaths(listOf(path))
        } else {
            finishCanceled()
        }
    }

    private val requestCameraPermission = registerForActivityResult(
        ActivityResultContracts.RequestPermission(),
    ) { granted: Boolean ->
        if (granted) {
            launchCamera()
        } else {
            finishCanceled()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState != null) {
            return
        }
        if (hasLaunchedPicker) {
            return
        }
        hasLaunchedPicker = true
        allowMultiple = intent.getBooleanExtra(EXTRA_ALLOW_MULTIPLE, false)
        when (intent.getStringExtra(EXTRA_MODE)) {
            MODE_GALLERY -> launchGallery()
            MODE_CAMERA -> openCameraWithPermission()
            else -> finishCanceled()
        }
    }

    private fun launchGallery() {
        val request = PickVisualMediaRequest(
            ActivityResultContracts.PickVisualMedia.ImageOnly,
        )
        if (allowMultiple) {
            pickMultipleMedia.launch(request)
        } else {
            pickSingleMedia.launch(request)
        }
    }

    private fun openCameraWithPermission() {
        val hasPermission: Boolean = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.CAMERA,
        ) == PackageManager.PERMISSION_GRANTED
        if (hasPermission) {
            launchCamera()
        } else {
            requestCameraPermission.launch(Manifest.permission.CAMERA)
        }
    }

    private fun launchCamera() {
        val photoFile = File(cacheDir, "camera_${System.currentTimeMillis()}.jpg")
        cameraPhotoFile = photoFile
        val photoUri: Uri = FileProvider.getUriForFile(
            this,
            "${applicationContext.packageName}.fileprovider",
            photoFile,
        )
        takePicture.launch(photoUri)
    }

    private fun copyUriToCache(uri: Uri): String? {
        return try {
            val outputFile = File(cacheDir, "gallery_${System.currentTimeMillis()}.jpg")
            contentResolver.openInputStream(uri)?.use { input ->
                outputFile.outputStream().use { output ->
                    input.copyTo(output)
                }
            } ?: return null
            outputFile.absolutePath
        } catch (_: IOException) {
            null
        }
    }

    private fun finishWithPaths(paths: List<String>) {
        setResult(
            RESULT_OK,
            Intent()
                .putStringArrayListExtra(EXTRA_PATHS, ArrayList(paths))
                .putExtra(EXTRA_PATH, paths.firstOrNull()),
        )
        finish()
    }

    private fun finishCanceled() {
        setResult(RESULT_CANCELED)
        finish()
    }

    companion object {
        const val EXTRA_MODE: String = "mode"
        const val EXTRA_PATH: String = "path"
        const val EXTRA_PATHS: String = "paths"
        const val EXTRA_ALLOW_MULTIPLE: String = "allow_multiple"
        const val MODE_GALLERY: String = "gallery"
        const val MODE_CAMERA: String = "camera"

        fun createIntent(
            context: Context,
            mode: String,
            allowMultiple: Boolean = false,
        ): Intent {
            return Intent(context, NativeImagePickerActivity::class.java)
                .putExtra(EXTRA_MODE, mode)
                .putExtra(EXTRA_ALLOW_MULTIPLE, allowMultiple)
        }
    }
}
