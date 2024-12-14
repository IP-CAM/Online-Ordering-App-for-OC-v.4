import 'dart:convert';

import 'package:ordering_app/features/theme/domain/entities/theme_entity.dart';

class ThemeModel extends ThemeEntity {
  ThemeModel({
    required super.isDarkMode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isDarkMode': isDarkMode,
    };
  }

  factory ThemeModel.fromMap(Map<String, dynamic> map) {
    return ThemeModel(
      isDarkMode: map['isDarkMode'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ThemeModel.fromJson(String source) =>
      ThemeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
