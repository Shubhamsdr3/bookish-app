package com.newaura.bookish.profile

/**
 * Snapshot of profile UI pushed from Flutter over [ProfileBridge].
 */
data class ProfileUiState(
    val status: String = STATUS_LOADING,
    val userName: String = "",
    val name: String = "",
    val phoneNumber: String = "",
    val profileIconUrl: String = "",
    val localImagePath: String = "",
    val appVersion: String = "",
    val isOwner: Boolean = false,
    val isImageUploading: Boolean = false,
    val isDebug: Boolean = false,
    val errorMessage: String = "",
) {
    companion object {
        const val STATUS_LOADING: String = "loading"
        const val STATUS_LOADED: String = "loaded"
        const val STATUS_ERROR: String = "error"
    }
}
