import 'dart:convert';

import 'package:ordering_app/core/common/entities/login_info_entity.dart';
import 'package:ordering_app/core/constants/db_constants.dart';
import 'package:ordering_app/core/database/db_column.dart';

class LoginInfoModel extends LoginInfoEntity {
  LoginInfoModel({
    required super.token,
    required super.deviceId,
    super.email,
    super.firstName,
    super.lastName,
    super.telephone,
    super.expiresAt,
  });

  // Static getter to access table name
  static String get table => DbTables.loginInfo;

  // Static method to get table structure
  static Map<String, DbColumn> getTableStructure() {
    return {
      DbColumns.id: DbColumn.integer().autoIncrement().notNull(),
      DbColumns.token: DbColumn.text().notNull(),
      DbColumns.deviceId: DbColumn.text().notNull(),
      DbColumns.email: DbColumn.text(),
      DbColumns.firstName: DbColumn.text(),
      DbColumns.lastName: DbColumn.text(),
      DbColumns.telephone: DbColumn.text(),
      DbColumns.expiresAt: DbColumn.text(),
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'deviceId':deviceId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'telephone': telephone,
      'expiresAt': expiresAt,
    };
  }

  factory LoginInfoModel.fromMap(Map<String, dynamic> map) {
    return LoginInfoModel(
      token: map['token'] as String,
      deviceId: map['deviceId'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      telephone: map['telephone'] != null ? map['telephone'] as String : null,
      expiresAt: map['expiresAt'] != null ? map['expiresAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginInfoModel.fromJson(String source) =>
      LoginInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
