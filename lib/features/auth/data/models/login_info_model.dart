import 'dart:convert';

import 'package:ordering_app/core/common/entities/login_info.dart';
import 'package:ordering_app/core/constants/db_constants.dart';
import 'package:ordering_app/core/database/db_column.dart';

class LoginInfoModel extends LoginInfoEntity {
  LoginInfoModel({
    required super.customerToken,
  });

  // Static getter to access table name
  static String get table => DbTables.loginInfo;

  // Static method to get table structure
  static Map<String, DbColumn> getTableStructure() {
    return {
      DbColumns.id: DbColumn.integer().autoIncrement().notNull(),
      DbColumns.customerToken: DbColumn.text().notNull(),
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customerToken': customerToken,
    };
  }

  factory LoginInfoModel.fromMap(Map<String, dynamic> map) {
    return LoginInfoModel(
      customerToken: map['customerToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginInfoModel.fromJson(String source) =>
      LoginInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
