package com.newaura.bookish.ui.theme

import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color

/**
 * Extra tokens that map to Flutter [BookishColor] beyond Material3 ColorScheme.
 */
@Immutable
data class BookishExtendedColors(
    val secondaryText: Color,
    val tertiaryText: Color,
    val border: Color,
    val success: Color,
    val focusBorder: Color,
    val screenBackground: Color,
    val avatarPlaceholder: Color,
    val brandYellow: Color,
)

val LocalBookishColors = staticCompositionLocalOf {
    lightBookishExtendedColors
}

val lightBookishExtendedColors: BookishExtendedColors = BookishExtendedColors(
    secondaryText = BookishColors.LightSecondaryText,
    tertiaryText = BookishColors.LightTertiaryText,
    border = BookishColors.LightBorder,
    success = BookishColors.LightSuccess,
    focusBorder = BookishColors.LightFocusBorder,
    screenBackground = BookishColors.LightScreenBackground,
    avatarPlaceholder = BookishColors.LightAvatarPlaceholder,
    brandYellow = BookishColors.BrandYellow,
)

val darkBookishExtendedColors: BookishExtendedColors = BookishExtendedColors(
    secondaryText = BookishColors.DarkSecondaryText,
    tertiaryText = BookishColors.DarkTertiaryText,
    border = BookishColors.DarkBorder,
    success = BookishColors.DarkSuccess,
    focusBorder = BookishColors.DarkFocusBorder,
    screenBackground = BookishColors.DarkScreenBackground,
    avatarPlaceholder = BookishColors.DarkAvatarPlaceholder,
    brandYellow = BookishColors.BrandYellow,
)
