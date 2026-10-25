package com.newaura.bookish.util

fun Map<*, *>.stringOr(key: String, default: String): String {
    val value: Any? = this[key]
    return value as? String ?: default
}

fun Map<*, *>.booleanOr(key: String, default: Boolean): Boolean {
    val value: Any? = this[key]
    return value as? Boolean ?: default
}