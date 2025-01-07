import 'dart:convert';

import 'package:ordering_app/features/address_book/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    required super.addressId,
    required super.firstName,
    required super.lastName,
    required super.company,
    required super.address1,
    required super.address2,
    required super.city,
    required super.postcode,
    required super.zone,
    required super.zoneCode,
    required super.country,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address_id': addressId,
      'firstname': firstName,
      'lastname': lastName,
      'company': company,
      'address1': address1,
      'address2': address2,
      'city': city,
      'postcode': postcode,
      'zone': zone,
      'zone_code': zoneCode,
      'country': country,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      addressId: map['address_id'] as int ,
      firstName: map['firstname'] as String,
      lastName: map['lastname'] as String,
      company: map['company'] != null ? map['company'] as String : null,
      address1: map['address_1'] as String,
      address2: map['address_2'] != null ? map['address_2'] as String : null,
      city: map['city'] as String,
      postcode: map['postcode'] as String,
      zone: map['zone'] as String,
      zoneCode: map['zone_code'] as String,
      country: map['country'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
