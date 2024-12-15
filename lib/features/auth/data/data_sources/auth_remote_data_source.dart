import 'package:flutter/material.dart';
import 'package:ordering_app/core/constants/urls.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/web_service.dart';
import 'package:ordering_app/features/auth/data/models/login_info_model.dart';

/// Contract for handling remote authentication operations
abstract interface class AuthRemoteDataSource {
  /// Authenticates user with email and password
  Future<LoginInfoModel> login({
    required String email,
    required String password,
  });

  /// Logs out the current user
  Future<void> logout({
    required String customerToken,
    required String deviceId,
  });

  /// Registers a new user
  Future<LoginInfoModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String telephone,
    required String password,
    required String confirm,
    required bool agree,
    required bool newsletter,
  });

  /// Validates the authentication token
  Future<bool> validateToken({
    required String customerToken,
    required String deviceId,
  });
}

/// Remote implementation of [AuthRemoteDataSource] using REST API
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final WebService _webService;

  /// Creates a data source instance with the provided [WebService]
  const AuthRemoteDataSourceImpl({
    required WebService webService,
  }) : _webService = webService;

  @override
  Future<LoginInfoModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _webService.post(
        endpoint: Urls.login,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.error != null) {
        throw response.error.toString();
      }

      // Transform the response data to match our model
      final responseData = response.data['data'];
      final authData = {
        'token': responseData['token'],
        'deviceId': responseData['device_id'],
        'email': responseData['customer']['email'],
        'firstName': responseData['customer']['firstname'],
        'lastName': responseData['customer']['lastname'],
        'telephone': responseData['customer']['telephone'],
        'expiresAt': responseData['expires_at'],
      };

      return LoginInfoModel.fromMap(authData);
    } catch (error, stackTrace) {
      debugPrint('Error during login: $error');
      debugPrint('Stack trace: $stackTrace');
      throw AppException(error.toString());
    }
  }

  @override
  Future<void> logout({
    required String customerToken,
    required String deviceId,
  }) async {
    try {
      final response = await _webService.post(
        endpoint: Urls.logout,
        body: {
          'token': customerToken,
          'device_id': deviceId,
        },
      );
      debugPrint(response.data.toString());
      if (response.error != null) {
        throw response.error.toString();
      }
    } catch (error, stackTrace) {
      debugPrint('Error during logout: $error');
      debugPrint('Stack trace: $stackTrace');
      throw AppException(error.toString());
    }
  }

  @override
  Future<LoginInfoModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String telephone,
    required String password,
    required String confirm,
    required bool agree,
    required bool newsletter,
  }) async {
    try {
      final response = await _webService.post(
        endpoint: Urls.register,
        body: {
          'firstname': firstName,
          'lastname': lastName,
          'email': email,
          'telephone': telephone,
          'password': password,
          'confirm': confirm,
          'agree': agree ? '1' : '0',
          'newsletter': newsletter ? '1' : '0',
        },
      );

      if (response.error != null) {
        throw response.error.toString();
      }

      // Transform the response data to match our model
      final responseData = response.data['data'];
      final authData = {
        'token': responseData['token'],
        'deviceId': responseData['device_id'],
        'email': responseData['customer']['email'],
        'firstName': responseData['customer']['firstname'],
        'lastName': responseData['customer']['lastname'],
        'telephone': responseData['customer']['telephone'],
        'expiresAt': responseData['expires_at'],
      };

      return LoginInfoModel.fromMap(authData);
    } catch (error, stackTrace) {
      debugPrint('Error during registration: $error');
      debugPrint('Stack trace: $stackTrace');
      throw AppException(error.toString());
    }
  }

  @override
  Future<bool> validateToken({
    required String customerToken,
    required String deviceId,
  }) async {
    try {
      final response = await _webService.post(
        endpoint: Urls.validateToken,
        body: {
          'token': customerToken,
          'device_id': deviceId,
        },
      );

      if (response.error != null) {
        throw response.error.toString();
      }
      return response.data['valid'] == true;
    } catch (error, stackTrace) {
      debugPrint('Error validating token: $error');
      debugPrint('Stack trace: $stackTrace');
      throw AppException(error.toString());
    }
  }
}
