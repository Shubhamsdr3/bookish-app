package com.newaura.bookish.ui.theme

import androidx.compose.ui.graphics.Color

/**
 * Color tokens aligned with Flutter:
 * - [lib/util/custom_colors.dart]
 * - [lib/uikit/light_bookish_color.dart] / [lib/uikit/dark_bookish_color.dart]
 * - Profile screen uses [Colors.grey.shade100] as page background
 */
object BookishColors {
    // CustomColors
    val BrandPrimary: Color = Color(0xFFF56C5F)
    val BrandGreen: Color = Color(0xFF228073)
    val BrandYellow: Color = Color(0xFFF5EBDA)

    // LightBookishColor
    val LightSurface: Color = Color.White
    val LightPrimaryText: Color = Color.Black
    val LightSecondaryText: Color = Color.Black.copy(alpha = 0.5f)
    val LightTertiaryText: Color = Color.Black.copy(alpha = 0.7f)
    val LightError: Color = Color(0xFFFF5252) // Colors.redAccent
    val LightBorder: Color = Color(0xFF9E9E9E) // Colors.grey
    val LightSuccess: Color = Color(0xFF4CAF50) // Colors.green
    val LightFocusBorder: Color = Color(0xFF03A9F4) // Colors.lightBlue
    val LightScreenBackground: Color = Color(0xFFF5F5F5) // Colors.grey.shade100
    val LightAvatarPlaceholder: Color = Color(0xFFBDBDBD) // Colors.grey.shade400

    // DarkBookishColor
    val DarkSurface: Color = Color.Black
    val DarkPrimaryText: Color = Color.White
    val DarkSecondaryText: Color = Color.White.copy(alpha = 0.5f)
    val DarkTertiaryText: Color = Color.White.copy(alpha = 0.7f)
    val DarkError: Color = Color(0xFFFF5252)
    val DarkBorder: Color = Color(0xFF9E9E9E)
    val DarkSuccess: Color = Color(0xFF4CAF50)
    val DarkFocusBorder: Color = Color(0xFF2196F3) // Colors.blue
    val DarkScreenBackground: Color = Color(0xFF121212)
    val DarkAvatarPlaceholder: Color = Color(0xFF616161)
}
