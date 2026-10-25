package com.newaura.bookish.profile

import android.util.Log
import com.newaura.bookish.util.booleanOr
import com.newaura.bookish.util.stringOr
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

/**
 * MethodChannel bridge for the Compose profile tab.
 * Flutter pushes [ProfileUiState]; native emits UI actions back.
 */
object ProfileBridge {

    const val CHANNEL: String = "com.newaura.bookish/native_profile"

    const val ACTION_EDIT_PROFILE: String = "editProfile"
    const val ACTION_SHARE_FEEDBACK: String = "shareFeedback"
    const val ACTION_OPEN_SETTINGS: String = "openSettings"
    const val ACTION_LOGOUT: String = "logout"
    const val ACTION_RETRY: String = "retry"
    const val ACTION_OPEN_GALLERY: String = "openGallery"
    const val ACTION_OPEN_CAMERA: String = "openCamera"

    private var channel: MethodChannel? = null
    private val _uiState: MutableStateFlow<ProfileUiState> =
        MutableStateFlow(ProfileUiState())
    val uiState: StateFlow<ProfileUiState> = _uiState.asStateFlow()

    fun attachChannel(messenger: BinaryMessenger) {
        Log.i("BookishProfile", "channel attached $CHANNEL")
        channel = MethodChannel(messenger, CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "updateState" -> {
                        val arguments: Map<*, *>? = call.arguments as? Map<*, *>
                        _uiState.value = parseState(arguments)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    fun detachChannel() {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    fun emitAction(action: String) {
        channel?.invokeMethod("onAction", mapOf("action" to action))
    }

    private fun parseState(arguments: Map<*, *>?): ProfileUiState {
        if (arguments == null) {
            return ProfileUiState()
        }
        return ProfileUiState(
            status = arguments.stringOr("status", ProfileUiState.STATUS_LOADING),
            userName = arguments.stringOr("userName", ""),
            name = arguments.stringOr("name", ""),
            phoneNumber = arguments.stringOr("phoneNumber", ""),
            profileIconUrl = arguments.stringOr("profileIconUrl", ""),
            localImagePath = arguments.stringOr("localImagePath", ""),
            appVersion = arguments.stringOr("appVersion", ""),
            isOwner = arguments.booleanOr("isOwner", false),
            isImageUploading = arguments.booleanOr("isImageUploading", false),
            isDebug = arguments.booleanOr("isDebug", false),
            errorMessage = arguments.stringOr("errorMessage", ""),
        )
    }
}
