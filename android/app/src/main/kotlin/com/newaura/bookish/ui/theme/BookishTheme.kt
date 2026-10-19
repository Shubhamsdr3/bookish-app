package com.newaura.bookish.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.graphics.Color

private val LightColorScheme = lightColorScheme(
    primary = BookishColors.BrandGreen,
    onPrimary = Color.White,
    secondary = BookishColors.BrandPrimary,
    onSecondary = Color.White,
    background = BookishColors.LightScreenBackground,
    onBackground = BookishColors.LightPrimaryText,
    surface = BookishColors.LightSurface,
    onSurface = BookishColors.LightPrimaryText,
    onSurfaceVariant = BookishColors.LightSecondaryText,
    error = BookishColors.LightError,
    onError = Color.White,
    outline = BookishColors.LightBorder,
)

private val DarkColorScheme = darkColorScheme(
    primary = BookishColors.BrandGreen,
    onPrimary = Color.White,
    secondary = BookishColors.BrandPrimary,
    onSecondary = Color.White,
    background = BookishColors.DarkScreenBackground,
    onBackground = BookishColors.DarkPrimaryText,
    surface = BookishColors.DarkSurface,
    onSurface = BookishColors.DarkPrimaryText,
    onSurfaceVariant = BookishColors.DarkSecondaryText,
    error = BookishColors.DarkError,
    onError = Color.White,
    outline = BookishColors.DarkBorder,
)

/**
 * Compose theme mirrored from Flutter [ThemeData] + [BookishColor] extensions.
 */
@Composable
fun BookishTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit,
) {
    val colorScheme = if (darkTheme) DarkColorScheme else LightColorScheme
    val extendedColors = if (darkTheme) {
        darkBookishExtendedColors
    } else {
        lightBookishExtendedColors
    }
    CompositionLocalProvider(LocalBookishColors provides extendedColors) {
        MaterialTheme(
            colorScheme = colorScheme,
            content = content,
        )
    }
}

object BookishThemeTokens {
    val colors: BookishExtendedColors
        @Composable
        get() = LocalBookishColors.current
}
