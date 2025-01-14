import 'dart:convert';

import 'package:ordering_app/features/checkout/domain/entities/total_entity.dart';

class TotalModel extends TotalEntity {
  TotalModel({
    required super.title,
    required super.value,
  });

    Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'value': value,
    };
  }

  factory TotalModel.fromMap(Map<String, dynamic> map) {
    return TotalModel(
      title: map['title'] as String,
      value: map['value'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TotalModel.fromJson(String source) => TotalModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
