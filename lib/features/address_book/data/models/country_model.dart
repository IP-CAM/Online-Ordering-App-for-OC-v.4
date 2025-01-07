import 'dart:convert';

import 'package:ordering_app/features/address_book/domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  CountryModel({
    required super.countryId,
    required super.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country_id': countryId,
      'name': name,
    };
  }

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      countryId: map['country_id'] is String ? int.parse( map['country_id']): map['country_id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryModel.fromJson(String source) =>
      CountryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
