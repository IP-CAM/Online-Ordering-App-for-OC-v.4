import 'package:flutter/material.dart';
import 'package:ordering_app/core/constants/db_constants.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/database_helper.dart';
import 'package:ordering_app/features/auth/data/models/login_info_model.dart';

abstract interface class AuthLocalDataSource {
  Future<void> login({required LoginInfoModel authInfo});

  Future<void> logout();

  Future<LoginInfoModel?> getLoginInfo();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final DatabaseHelper _db;

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
      await logout();

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
