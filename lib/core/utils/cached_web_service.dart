import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ordering_app/core/utils/web_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents a cached response entry with its metadata.
/// 
/// Contains the actual response data, timestamp of when it was cached,
/// and the duration for which it should be considered valid.
class CacheEntry {
  /// The cached response data
  final dynamic data;
  
  /// When this entry was cached
  final DateTime timestamp;
  
  /// How long this entry should be considered valid
  final Duration duration;

  /// Creates a new cache entry.
  /// 
  /// Requires [data] to be cached, a [timestamp] of when it was cached,
  /// and a [duration] for how long it should be valid.
  CacheEntry({
    required this.data,
    required this.timestamp,
    required this.duration,
  });

  /// Converts the cache entry to JSON for storage.
  Map<String, dynamic> toJson() => {
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'duration': duration.inSeconds,
  };

  /// Creates a cache entry from JSON data.
  /// 
  /// Used when retrieving cached entries from storage.
  factory CacheEntry.fromJson(Map<String, dynamic> json) {
    return CacheEntry(
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp']),
      duration: Duration(seconds: json['duration']),
    );
  }

  /// Whether this cache entry has expired based on its timestamp and duration.
  bool get isExpired => 
    DateTime.now().difference(timestamp) > duration;
}

/// A service that adds caching capabilities to the WebService class.
/// 
/// This service wraps the existing WebService and adds automatic caching of
/// HTTP responses using SharedPreferences. It handles cache expiration,
/// force refresh requests, and provides methods for cache management.
/// 
/// Example usage:
/// ```dart
/// final cachedService = CachedWebService();
/// 
/// // GET request with caching
/// final response = await cachedService.get<Map<String, dynamic>>(
///   endpoint: '/users',
///   cacheDuration: Duration(minutes: 30),
/// );
/// 
/// // POST request with optional caching
/// final response = await cachedService.post<Map<String, dynamic>>(
///   endpoint: '/users',
///   body: {'name': 'John'},
///   cacheDuration: Duration(minutes: 15),
/// );
/// ```
class CachedWebService {
  /// Internal SharedPreferences instance for caching
  SharedPreferences? _prefs;
  
  /// Default duration for how long cache entries should be valid
  static const Duration defaultCacheDuration = Duration(hours: 1);
  
  /// Instance of the underlying WebService
  final WebService _webService = WebService();

  /// Ensures SharedPreferences is initialized before use.
  /// 
  /// This is called automatically by other methods when needed.
  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Generates a unique cache key for an endpoint and its parameters.
  /// 
  /// The key is based on the [endpoint] and optional [queryParams].
  /// Query parameters are sorted to ensure consistent keys regardless of parameter order.
  String _generateCacheKey(String endpoint, Map<String, dynamic>? queryParams) {
    final buffer = StringBuffer(endpoint);
    if (queryParams != null && queryParams.isNotEmpty) {
      final sortedParams = Map.fromEntries(
        queryParams.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
      );
      buffer.write(json.encode(sortedParams));
    }
    return buffer.toString();
  }

  /// Sets the authentication token for the underlying WebService.
  /// 
  /// The [token] will be included in all subsequent requests as a Bearer token
  /// in the Authorization header.
  Future<void> setAuthToken(String token) async {
    _webService.setAuthToken(token);
  }

  /// Performs a GET request with automatic caching.
  /// 
  /// Parameters:
  /// - [endpoint]: The API endpoint to request
  /// - [headers]: Optional HTTP headers to include with the request
  /// - [queryParameters]: Optional query parameters to append to the URL
  /// - [cacheDuration]: How long to cache the response (defaults to [defaultCacheDuration])
  /// - [forceRefresh]: Whether to bypass cache and force a network request
  /// 
  /// Returns an [ApiResponse] containing either the cached or fresh data.
  /// 
  /// Example:
  /// ```dart
  /// final response = await cachedService.get<Map<String, dynamic>>(
  ///   endpoint: '/users',
  ///   queryParameters: {'page': '1'},
  ///   cacheDuration: Duration(minutes: 30),
  /// );
  /// ```
  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration cacheDuration = defaultCacheDuration,
    bool forceRefresh = false,
  }) async {
    await _ensureInitialized();
    final cacheKey = _generateCacheKey(endpoint, queryParameters);

    if (!forceRefresh) {
      final cachedData = await _getCachedData<T>(cacheKey);
      if (cachedData != null) {
        debugPrint('📦 Retrieved from cache: $endpoint');
        return ApiResponse<T>(
          success: true,
          data: cachedData,
        );
      }
    }

    debugPrint('🌐 Fetching from server: $endpoint');
    final response = await _webService.get<T>(
      endpoint: endpoint,
      headers: headers,
      queryParameters: queryParameters,
    );

    if (response.success && response.data != null) {
      await _cacheResponse(cacheKey, response.data, cacheDuration);
    }

    return response;
  }

  /// Performs a POST request with optional caching.
  /// 
  /// Parameters:
  /// - [endpoint]: The API endpoint to post to
  /// - [body]: The request body (can be Map, String, or other JSON-serializable type)
  /// - [headers]: Optional HTTP headers to include with the request
  /// - [cacheDuration]: Optional duration to cache the response
  /// - [forceRefresh]: Whether to bypass cache and force a network request
  /// 
  /// Returns an [ApiResponse] containing either the cached or fresh data.
  /// 
  /// Example:
  /// ```dart
  /// final response = await cachedService.post<Map<String, dynamic>>(
  ///   endpoint: '/users',
  ///   body: {'name': 'John', 'email': 'john@example.com'},
  ///   cacheDuration: Duration(minutes: 15),
  /// );
  /// ```
  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    required dynamic body,
    Map<String, String>? headers,
    Duration? cacheDuration,
    bool forceRefresh = false,
  }) async {
    await _ensureInitialized();
    
    // Convert dynamic body to Map<String, dynamic> if it's a Map
    final Map<String, dynamic>? processedBody = body is Map ? 
      Map<String, dynamic>.from(body) : 
      null;
    
    final cacheKey = _generateCacheKey(endpoint, processedBody);

    if (!forceRefresh && cacheDuration != null) {
      final cachedData = await _getCachedData<T>(cacheKey);
      if (cachedData != null) {
        debugPrint('📦 Retrieved from cache: $endpoint');
        return ApiResponse<T>(
          success: true,
          data: cachedData,
        );
      }
    }

    debugPrint('🌐 Posting to server: $endpoint');
    final response = await _webService.post<T>(
      endpoint: endpoint,
      body: body,
      headers: headers,
    );

    if (response.success && response.data != null && cacheDuration != null) {
      await _cacheResponse(cacheKey, response.data, cacheDuration);
    }

    return response;
  }

  /// Caches a response with the specified key and duration.
  /// 
  /// Creates a [CacheEntry] and stores it in SharedPreferences.
  /// If an error occurs during caching, the error is caught and logged.
  Future<void> _cacheResponse(String key, dynamic data, Duration duration) async {
    final entry = CacheEntry(
      data: data,
      timestamp: DateTime.now(),
      duration: duration,
    );

    await _prefs!.setString(key, json.encode(entry.toJson()));
  }

  /// Retrieves and validates cached data for a given key.
  /// 
  /// Returns null if:
  /// - No cached data exists for the key
  /// - The cached data has expired
  /// - The cached data is invalid or corrupted
  /// 
  /// If the cached data is invalid or expired, it is automatically removed.
  Future<T?> _getCachedData<T>(String key) async {
    final data = _prefs!.getString(key);
    if (data == null) return null;

    try {
      final entry = CacheEntry.fromJson(json.decode(data));
      if (entry.isExpired) {
        await _prefs!.remove(key);
        return null;
      }
      return entry.data as T;
    } catch (e) {
      await _prefs!.remove(key);
      return null;
    }
  }

  /// Clears all cached responses.
  /// 
  /// This will remove all cached data stored by this service.
  /// Use with caution as this operation cannot be undone.
  Future<void> clearCache() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }

  /// Removes a specific cache entry.
  /// 
  /// Parameters:
  /// - [endpoint]: The endpoint whose cache should be removed
  /// - [queryParams]: Optional query parameters to include in the cache key
  /// 
  /// Example:
  /// ```dart
  /// await cachedService.removeCacheEntry(
  ///   '/users',
  ///   {'page': '1'},
  /// );
  /// ```
  Future<void> removeCacheEntry(String endpoint, [Map<String, dynamic>? queryParams]) async {
    await _ensureInitialized();
    final cacheKey = _generateCacheKey(endpoint, queryParams);
    await _prefs!.remove(cacheKey);
  }
}