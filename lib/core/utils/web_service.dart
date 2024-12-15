import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ordering_app/core/constants/urls.dart';

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
  static const int timeoutDuration = 30;

  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static final WebService _instance = WebService._internal();

  factory WebService() {
    return _instance;
  }

  WebService._internal();

  void setAuthToken(String token) {
    _defaultHeaders['Authorization'] = 'Bearer $token';
  }

  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Uri uri = Uri.parse('${Urls.baseUrl}$endpoint').replace(
        queryParameters: queryParameters,
      );

      final Map<String, String> adjustedHeaders = {
        ..._defaultHeaders,
        ...?headers,
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final http.Response response = await http
          .get(
            uri,
            headers: adjustedHeaders,
          )
          .timeout(const Duration(seconds: timeoutDuration));

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        error: _handleError(e),
      );
    }
  }

  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    required dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final Uri uri = Uri.parse('${Urls.baseUrl}$endpoint');

      final String processedBody = _processRequestBody(body);

      final Map<String, String> adjustedHeaders = {
        ..._defaultHeaders,
        ...?headers,
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final http.Response response = await http
          .post(
            uri,
            headers: adjustedHeaders,
            body: processedBody,
            encoding: Encoding.getByName('utf-8'),
          )
          .timeout(const Duration(seconds: timeoutDuration));

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        error: _handleError(e),
      );
    }
  }

  String _processRequestBody(dynamic body) {
    if (body is Map<String, dynamic>) {
      return body.entries
          .map((MapEntry<String, dynamic> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');
    } else if (body is String) {
      return body;
    } else {
      return json.encode(body);
    }
  }

  ApiResponse<T> _handleResponse<T>(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final dynamic decodedBody = json.decode(response.body);
        if (decodedBody is Map) {
          if (decodedBody.containsKey('error')) {
            return ApiResponse<T>(
              success: false,
              error: decodedBody['error']['warning'] ?? 'Unknown error!',
            );
          }
        }
        return ApiResponse<T>(
          success: true,
          data: decodedBody as T,
        );
      } catch (e) {
        return ApiResponse<T>(
          success: false,
          error: 'Failed to decode response',
        );
      }
    } else {
      return ApiResponse<T>(
        success: false,
        error: _getErrorMessage(response),
      );
    }
  }

  String _handleError(dynamic error) {
    if (error is http.ClientException) {
      return 'Network error occurred';
    } else if (error is FormatException) {
      return 'Invalid format error';
    } else if (error is TimeoutException) {
      return 'Request timed out';
    } else {
      return 'An unexpected error occurred';
    }
  }

  String _getErrorMessage(http.Response response) {
    try {
      final Map<String, dynamic> body = json.decode(response.body);
      return body['message'] as String? ?? 'Unknown error occurred';
    } catch (e) {
      return 'Error ${response.statusCode}: ${response.reasonPhrase}';
    }
  }
}
