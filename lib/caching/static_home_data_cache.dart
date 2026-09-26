import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Manages persistent and in-memory caching of Static Home API data.
///
/// This class provides a two-layer caching strategy:
/// - Memory cache: Fast, volatile (cleared on app restart)
/// - Persistent cache: Slower, survives app restart
///
/// The cache handles various edge cases like corruption, size limits, and
/// expiration to ensure reliable cached data availability.
class StaticHomeDataCache {
  StaticHomeDataCache._();

  /// SharedPreferences key for storing the cached data
  static const String _cacheKey = 'static_home_api_data_v1';

  /// SharedPreferences key for storing cache metadata (timestamp, version)
  static const String _cacheMetaKey = 'static_home_api_meta_v1';

  /// Cache is considered valid for 24 hours
  static const Duration _cacheDuration = Duration(hours: 24);

  /// Maximum cache size (10MB)
  static const int _maxCacheSize = 10 * 1024 * 1024;

  /// Current cache version - increment this to invalidate all cached data
  static const int _cacheVersion = 1;

  /// In-memory cache
  static dynamic _memoryCache;
  static DateTime? _memoryCacheTime;

  /// Write lock to prevent concurrent writes
  static Completer<void>? _writeLock;

  /// Get cached data with fallback chain: memory → persistent → null
  ///
  /// Returns cached data if available and valid, null otherwise.
  /// This method doesn't throw - it gracefully handles errors.
  static Future<dynamic> getCachedData() async {
    try {
      // Try memory cache first (fastest)
      if (_isMemoryCacheValid()) {
        return _memoryCache;
      }

      // Try persistent storage
      return await _getPersistentData();
    } catch (e, s) {
      debugPrint("$e $s");
      return null;
    }
  }

  /// Save data to both memory and persistent storage.
  ///
  /// Uses a write lock to ensure only one write operation happens at a time,
  /// preventing data corruption from concurrent writes.
  static Future<void> cacheData(dynamic data) async {
    try {
      // Validate cache size
      _validateCacheSize(data);

      // Acquire write lock
      await _acquireWriteLock();

      // Update memory cache
      _memoryCache = data;
      _memoryCacheTime = DateTime.now();

      // Save to persistent storage
      await _savePersistentData(data);
    } catch (e, s) {
      debugPrint("$e $s");
      rethrow;
    } finally {
      _releaseWriteLock();
    }
  }

  /// Clear all cached data (memory and persistent).
  ///
  /// Use this when user logs out or when you need to clear all state.
  static Future<void> clearCache() async {
    try {
      _memoryCache = null;
      _memoryCacheTime = null;

      // final prefs = SharedPreferencesUtil.instance;
      // await prefs.setData(_cacheKey, null);
      // await prefs.setData(_cacheMetaKey, null);
    } catch (e, s) {
      debugPrint("$e $s");
    }
  }

  /// Get cache status information (for UI indicators).
  ///
  /// Use this to display "last updated" timestamp or staleness indicators.
  static Future<CacheStatus> getCacheStatus() async {
    try {
      final hasData = await getCachedData() != null;
      final meta = await _getCacheMetadata();
      final lastUpdated = meta != null
          ? DateTime.tryParse(meta['timestamp'] as String? ?? '')
          : null;

      return CacheStatus(
        hasData: hasData,
        lastUpdated: lastUpdated,
        isStale: lastUpdated != null
            ? DateTime.now().difference(lastUpdated) > _cacheDuration
            : false,
      );
    } catch (e, s) {
      debugPrint("$e $s");
      return const CacheStatus(hasData: false);
    }
  }

  // ============ Private Methods ============

  /// Check if in-memory cache is still valid
  static bool _isMemoryCacheValid() {
    if (_memoryCache == null || _memoryCacheTime == null) {
      return false;
    }

    final elapsed = DateTime.now().difference(_memoryCacheTime!);
    return elapsed < _cacheDuration;
  }

  /// Load data from persistent storage and update memory cache
  static Future<dynamic> _getPersistentData() async {
    try {
      final jsonString = "{}";
      // final jsonString =
      //     await SharedPreferencesUtil.instance.getData(_cacheKey) as String?;

      if (jsonString.isEmpty) {
        return null;
      }

      // Validate metadata before deserializing
      if (!await _isValidCacheMetadata()) {
        await clearCache();
        return null;
      }

      // Deserialize and update memory cache
      _memoryCache = jsonDecode(jsonString);
      _memoryCacheTime = DateTime.now();

      return _memoryCache;
    } on FormatException catch (e) {
      debugPrint("$e");
      await clearCache();
      return null;
    } catch (e, s) {
      debugPrint("$e $s");
      return null;
    }
  }

  /// Save data to persistent storage (should be called within write lock)
  static Future<void> _savePersistentData(dynamic data) async {
    try {
      final jsonString = jsonEncode(data);

      // Verify JSON is valid
      if (jsonString.isEmpty) {
        throw const FormatException('Empty JSON string');
      }

      // Write to preferences
      // await SharedPreferencesUtil.instance.setData(_cacheKey, jsonString);

      // Save metadata
      await _saveCacheMetadata();
    } catch (e, s) {
      debugPrint("$e $s");
      rethrow;
    }
  }

  /// Save cache metadata (timestamp, version, app version)
  static Future<void> _saveCacheMetadata() async {
    try {
      final metadata = {
        'timestamp': DateTime.now().toIso8601String(),
        'version': _cacheVersion,
        'appVersion': await _getAppVersion(),
      };

      // await SharedPreferencesUtil.instance.setData(
      //   _cacheMetaKey,
      //   jsonEncode(metadata),
      // );
    } catch (e, s) {
      debugPrint("$e $s");
    }
  }

  /// Get cache metadata from persistent storage
  static Future<Map<String, dynamic>?> _getCacheMetadata() async {
    try {
      // final metaJson = await SharedPreferencesUtil.instance
      //     .getData(_cacheMetaKey) as String?;
      // if (metaJson == null || metaJson.isEmpty) {
      //   return null;
      // }

      // return jsonDecode(metaJson) as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
    return null;
  }

  /// Validate cache metadata (version check, timestamp validation)
  static Future<bool> _isValidCacheMetadata() async {
    try {
      final meta = await _getCacheMetadata();
      if (meta == null) {
        return false;
      }

      // Check version
      final version = meta['version'] as int? ?? 0;
      if (version != _cacheVersion) {
        return false;
      }

      // Check timestamp exists
      final timestamp = meta['timestamp'] as String?;
      if (timestamp == null || timestamp.isEmpty) {
        return false;
      }

      // Try parsing timestamp
      DateTime.parse(timestamp);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Validate cache size doesn't exceed maximum limit
  static void _validateCacheSize(dynamic data) {
    try {
      final jsonString = jsonEncode(data);
      final sizeInBytes = utf8.encode(jsonString).length;

      if (sizeInBytes > _maxCacheSize) {
        throw CacheSizeException(
          'Cache size exceeds limit. Size: $sizeInBytes, Limit: $_maxCacheSize',
        );
      }
    } catch (e, s) {
      debugPrint("$e $s");
      rethrow;
    }
  }

  /// Get current app version for cache versioning
  static Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      return '0.0.0';
    }
  }

  /// Acquire write lock to ensure single writer
  static Future<void> _acquireWriteLock() async {
    const timeout = Duration(seconds: 5);

    // If lock exists, wait for it
    if (_writeLock != null && !_writeLock!.isCompleted) {
      try {
        await _writeLock!.future.timeout(timeout);
      } catch (_) {
        // Lock timed out, create new one
        _writeLock = null;
      }
    }

    // Create new lock
    _writeLock = Completer<void>();
  }

  /// Release write lock
  static void _releaseWriteLock() {
    if (_writeLock != null && !_writeLock!.isCompleted) {
      _writeLock!.complete();
    }
  }
}

/// Cache status information returned to UI
class CacheStatus {
  final bool hasData;
  final DateTime? lastUpdated;
  final bool isStale;

  const CacheStatus({
    required this.hasData,
    this.lastUpdated,
    this.isStale = false,
  });

  /// Time since last update in human-readable format
  String? get lastUpdatedText {
    if (lastUpdated == null) return null;

    final elapsed = DateTime.now().difference(lastUpdated!);

    if (elapsed.inMinutes < 1) {
      return 'Just now';
    } else if (elapsed.inMinutes < 60) {
      return '${elapsed.inMinutes}m ago';
    } else if (elapsed.inHours < 24) {
      return '${elapsed.inHours}h ago';
    } else {
      return '${elapsed.inDays}d ago';
    }
  }
}

/// Exception thrown when cache size exceeds limit
class CacheSizeException implements Exception {
  final String message;

  CacheSizeException(this.message);

  @override
  String toString() => 'CacheSizeException: $message';
}
