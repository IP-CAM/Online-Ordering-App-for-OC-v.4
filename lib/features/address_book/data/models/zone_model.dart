import 'dart:convert';

import 'package:ordering_app/features/address_book/domain/entities/zone_entity.dart';

class ZoneModel extends ZoneEntity {
  ZoneModel({
    required super.zoneId,
    required super.countryId,
    required super.name,
    required super.code,
    required super.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'zone_id': zoneId,
      'country_id': countryId,
      'name': name,
      'code': code,
      'status': status,
    };
  }

  factory ZoneModel.fromMap(Map<String, dynamic> map) {
    return ZoneModel(
      zoneId: map['zone_id'] is String
          ? int.parse(map['zone_id'])
          : map['zone_id'] as int,
      countryId: map['country_id'] is String
          ? int.parse(map['country_id'])
          : map['country_id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      status: map['status'] == 1 ? true : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ZoneModel.fromJson(String source) =>
      ZoneModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
