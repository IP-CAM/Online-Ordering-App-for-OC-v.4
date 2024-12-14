import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool success;

  ApiResponse({
    this.data,
    this.error,
    required this.success,
  });
}

class WebService {
  static const String baseUrl =
      'https://api.example.com'; // Replace with your API base URL
  static const int timeoutDuration = 30; // Timeout in seconds

  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Singleton pattern
  static final WebService _instance = WebService._internal();

  factory WebService() {
    return _instance;
  }

  WebService._internal();

  // Set auth token
  void setAuthToken(String token) {
    _defaultHeaders['Authorization'] = 'Bearer $token';
  }

  // GET request
  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters,
      );

      final response = await http.get(
        uri,
        headers: {..._defaultHeaders, ...?headers},
      ).timeout(const Duration(seconds: timeoutDuration));

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        error: _handleError(e),
      );
    }
  }

  // POST request
  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    required dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http
          .post(
            uri,
            headers: {..._defaultHeaders, ...?headers},
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: timeoutDuration));

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse(
        success: false,
        error: _handleError(e),
      );
    }
  }

  // Handle API response
  ApiResponse<T> _handleResponse<T>(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        success: true,
        data: json.decode(response.body) as T,
      );
    } else {
      return ApiResponse(
        success: false,
        error: _getErrorMessage(response),
      );
    }
  }

  // Handle errors
  String _handleError(dynamic error) {
    if (error is http.ClientException) {
      return 'Network error occurred';
    } else if (error is FormatException) {
      return 'Invalid response format';
    } else if (error is TimeoutException) {
      return 'Request timed out';
    } else {
      return 'An unexpected error occurred';
    }
  }

  // Get error message from response
  String _getErrorMessage(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['message'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'Error ${response.statusCode}: ${response.reasonPhrase}';
    }
  }
}
