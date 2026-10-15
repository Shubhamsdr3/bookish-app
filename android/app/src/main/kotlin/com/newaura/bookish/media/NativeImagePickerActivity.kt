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
 * Owns gallery/camera Activity Result contracts and returns a local file path.
 * [com.newaura.bookish.MainActivity] only starts this activity and forwards the path to Flutter.
 */
class NativeImagePickerActivity : ComponentActivity() {

    private var cameraPhotoFile: File? = null
    private var hasLaunchedPicker: Boolean = false

    private val pickMedia = registerForActivityResult(
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
            finishWithPath(path)
        }
    }

    private val takePicture = registerForActivityResult(
        ActivityResultContracts.TakePicture(),
    ) { success: Boolean ->
        val path: String? = cameraPhotoFile?.absolutePath
        if (success && path != null) {
            finishWithPath(path)
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
        when (intent.getStringExtra(EXTRA_MODE)) {
            MODE_GALLERY -> launchGallery()
            MODE_CAMERA -> openCameraWithPermission()
            else -> finishCanceled()
        }
    }

    private fun launchGallery() {
        pickMedia.launch(
            PickVisualMediaRequest(
                ActivityResultContracts.PickVisualMedia.ImageOnly,
            ),
        )
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

    private fun finishWithPath(path: String) {
        setResult(
            RESULT_OK,
            Intent().putExtra(EXTRA_PATH, path),
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
        const val MODE_GALLERY: String = "gallery"
        const val MODE_CAMERA: String = "camera"

        fun createIntent(context: Context, mode: String): Intent {
            return Intent(context, NativeImagePickerActivity::class.java)
                .putExtra(EXTRA_MODE, mode)
        }
    }
}
