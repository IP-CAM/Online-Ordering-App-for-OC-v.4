import 'package:flutter/material.dart';
import 'package:ordering_app/core/constants/db_constants.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/database_helper.dart';
import 'package:ordering_app/features/auth/data/models/login_info_model.dart';


/// Abstract interface for handling local authentication operations
abstract interface class AuthLocalDataSource {
  /// Stores the authentication information
  Future<void> login({required LoginInfoModel authInfo});

  /// Removes stored authentication data
  Future<void> logout();

  /// Retrieves stored authentication information
  Future<LoginInfoModel?> getLoginInfo();
}

/// Implementation of [AuthLocalDataSource] using SQLite database
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final DatabaseHelper _db;

  /// Creates an instance with the required [DatabaseHelper]
  const AuthLocalDataSourceImpl(DatabaseHelper databaseHelper)
      : _db = databaseHelper;

  @override
  Future<LoginInfoModel?> getLoginInfo() async {
    try {
      final result = await _db.first(
        DbTables.loginInfo,
      );

      if (result == null) return null;

      return LoginInfoModel.fromMap(result);
    } catch (e, stackTrace) {
      debugPrint('Error getting auth info: $e');
      debugPrint('Stack trace: $stackTrace');
      throw DatabaseException(
          'Failed to retrieve authentication information: ${e.toString()}');
    }
  }

  @override
  Future<void> login({required LoginInfoModel authInfo}) async {
    try {
      // First clear any existing auth data
      await logout();

      // Insert new auth information
      await _db.insert(
        DbTables.loginInfo,
        authInfo.toMap(),
      );
    } catch (e, stackTrace) {
      debugPrint('Error during login: $e');
      debugPrint('Stack trace: $stackTrace');
      throw DatabaseException(
          'Failed to store authentication information: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _db.truncate(DbTables.loginInfo);
    } catch (e, stackTrace) {
      debugPrint('Error during logout: $e');
      debugPrint('Stack trace: $stackTrace');
      throw DatabaseException(
          'Failed to clear authentication information: ${e.toString()}');
    }
  }
}