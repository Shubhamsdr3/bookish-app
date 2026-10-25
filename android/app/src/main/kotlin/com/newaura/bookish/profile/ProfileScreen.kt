package com.newaura.bookish.profile

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Phone
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import com.newaura.bookish.R
import com.newaura.bookish.ui.theme.BookishThemeTokens
import java.io.File

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ProfileScreen() {
    val state: ProfileUiState by ProfileBridge.uiState.collectAsState()
    var isChooserVisible: Boolean by remember { mutableStateOf(false) }
    val colorScheme = MaterialTheme.colorScheme
    // HomeScreen uses SafeArea(top: false); TopAppBar applies status-bar insets once.
    Scaffold(
        contentWindowInsets = WindowInsets(0, 0, 0, 0),
        topBar = {
            TopAppBar(
                title = { Text(text = "Profile") },
                actions = {
                    if (state.isOwner) {
                        IconButton(
                            onClick = {
                                ProfileBridge.emitAction(ProfileBridge.ACTION_EDIT_PROFILE)
                            },
                        ) {
                            Icon(
                                imageVector = Icons.Filled.Edit,
                                contentDescription = "Edit profile",
                            )
                        }
                    }
                },
            )
        },
        containerColor = colorScheme.background,
    ) { padding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding),
        ) {
            when (state.status) {
                ProfileUiState.STATUS_ERROR -> ProfileErrorContent(
                    message = state.errorMessage.ifEmpty { "Something went wrong" },
                    onRetry = { ProfileBridge.emitAction(ProfileBridge.ACTION_RETRY) },
                )
                ProfileUiState.STATUS_LOADED -> ProfileLoadedContent(
                    state = state,
                    onAvatarClick = { isChooserVisible = true },
                )
                else -> Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center,
                ) {
                    CircularProgressIndicator()
                }
            }
        }
    }
    if (isChooserVisible) {
        AlertDialog(
            onDismissRequest = { isChooserVisible = false },
            title = { Text(text = "Choose profile picture") },
            text = {
                Column {
                    TextButton(
                        onClick = {
                            isChooserVisible = false
                            ProfileBridge.emitAction(ProfileBridge.ACTION_OPEN_GALLERY)
                        },
                    ) {
                        Text(text = "Gallery")
                    }
                    TextButton(
                        onClick = {
                            isChooserVisible = false
                            ProfileBridge.emitAction(ProfileBridge.ACTION_OPEN_CAMERA)
                        },
                    ) {
                        Text(text = "Camera")
                    }
                }
            },
            confirmButton = {
                TextButton(onClick = { isChooserVisible = false }) {
                    Text(text = "Cancel")
                }
            },
        )
    }
}

@Composable
private fun ProfileErrorContent(
    message: String,
    onRetry: () -> Unit,
) {
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Text(text = "Error: $message")
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = onRetry) {
            Text(text = "Retry")
        }
    }
}

@Composable
private fun ProfileLoadedContent(
    state: ProfileUiState,
    onAvatarClick: () -> Unit,
) {
    Box(modifier = Modifier.fillMaxSize()) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(4.dp),
        ) {
            Surface(
                color = MaterialTheme.colorScheme.surface,
                modifier = Modifier.fillMaxWidth(),
            ) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(220.dp),
                    contentAlignment = Alignment.Center,
                ) {
                    ProfileAvatar(
                        state = state,
                        onClick = onAvatarClick,
                    )
                }
            }
            Spacer(modifier = Modifier.height(4.dp))
            Surface(
                color = MaterialTheme.colorScheme.surface,
                modifier = Modifier.fillMaxWidth(),
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    ProfileInfoRow(
                        title = "User name",
                        subtitle = state.userName,
                        icon = {
                            Icon(
                                imageVector = Icons.Filled.Person,
                                contentDescription = "User name",
                            )
                        },
                    )
                    if (state.name.isNotEmpty()) {
                        HorizontalDivider()
                        ProfileInfoRow(
                            title = "Name",
                            subtitle = state.name,
                            icon = {
                                Icon(
                                    imageVector = Icons.Filled.Person,
                                    contentDescription = "Name",
                                )
                            },
                        )
                    }
                    HorizontalDivider()
                    ProfileInfoRow(
                        title = "Phone number",
                        subtitle = if (state.isOwner) {
                            state.phoneNumber
                        } else {
                            "+91 **********"
                        },
                        icon = {
                            Icon(
                                imageVector = Icons.Filled.Phone,
                                contentDescription = "Phone number",
                            )
                        },
                    )
                    HorizontalDivider()
                    ProfileActionRow(
                        label = "Share feedback",
                        onClick = {
                            ProfileBridge.emitAction(ProfileBridge.ACTION_SHARE_FEEDBACK)
                        },
                        icon = {
                            Icon(
                                painter = painterResource(id = R.drawable.ic_feedback),
                                contentDescription = "Share feedback",
                            )
                        },
                    )
                    if (state.isDebug) {
                        HorizontalDivider()
                        ProfileActionRow(
                            label = "Setting",
                            onClick = {
                                ProfileBridge.emitAction(ProfileBridge.ACTION_OPEN_SETTINGS)
                            },
                            icon = {
                                Icon(
                                    imageVector = Icons.Filled.Settings,
                                    contentDescription = "Setting",
                                )
                            },
                        )
                    }
                    HorizontalDivider()
                    ProfileActionRow(
                        label = "Logout",
                        onClick = {
                            ProfileBridge.emitAction(ProfileBridge.ACTION_LOGOUT)
                        },
                        icon = {
                            Icon(
                                painter = painterResource(id = R.drawable.outline_logout_24),
                                contentDescription = "Logout",
                            )
                        },
                    )
                }
            }
            Spacer(modifier = Modifier.height(48.dp))

            Text(
                text = "v${state.appVersion}",
                color = BookishThemeTokens.colors.secondaryText,
                style = MaterialTheme.typography.bodySmall,
                modifier = Modifier.align(Alignment.CenterHorizontally)
                    .padding(bottom = 16.dp),
            )
        }
    }
}

@Composable
private fun ProfileAvatar(
    state: ProfileUiState,
    onClick: () -> Unit,
) {
    Box(
        modifier = Modifier
            .size(160.dp)
            .clickable(onClick = onClick),
        contentAlignment = Alignment.Center,
    ) {
        val model: Any? = when {
            state.localImagePath.isNotEmpty() -> File(state.localImagePath)
            state.profileIconUrl.isNotEmpty() -> state.profileIconUrl
            else -> null
        }
        if (model == null) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .clip(CircleShape)
                    .background(BookishThemeTokens.colors.avatarPlaceholder),
                contentAlignment = Alignment.Center,
            ) {
                Icon(
                    imageVector = Icons.Filled.Person,
                    contentDescription = null,
                    modifier = Modifier.size(72.dp),
                    tint = MaterialTheme.colorScheme.onPrimary,
                )
            }
        } else {
            AsyncImage(
                model = model,
                contentDescription = "Profile photo",
                contentScale = ContentScale.Crop,
                modifier = Modifier
                    .fillMaxSize()
                    .clip(CircleShape),
            )
        }
        if (state.isImageUploading) {
            CircularProgressIndicator()
        }
        Icon(
            painter = painterResource(id = R.drawable.outline_photo_camera_24),
            contentDescription = "camera",
            tint = MaterialTheme.colorScheme.primary,
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .padding(8.dp)
                .size(32.dp),
        )
    }
}

@Composable
private fun ProfileInfoRow(
    title: String,
    subtitle: String,
    icon: @Composable () -> Unit,
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        icon()
        Spacer(modifier = Modifier.width(12.dp))
        Column {
            Text(text = title, style = MaterialTheme.typography.labelMedium)
            Text(text = subtitle, style = MaterialTheme.typography.bodyLarge)
        }
    }
}

@Composable
private fun ProfileActionRow(
    label: String,
    onClick: () -> Unit,
    icon: @Composable () -> Unit,
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        icon()
        Spacer(modifier = Modifier.width(12.dp))
        Text(text = label, style = MaterialTheme.typography.bodyLarge)
    }
}
