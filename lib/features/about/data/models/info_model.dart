import 'dart:convert';

import 'package:ordering_app/features/about/domain/entities/info_entity.dart';

class InfoModel extends InfoEntity {
  InfoModel({
    required super.about,
    required super.deliveryInfo,
    required super.contact,
    required super.openingTimes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'about': (about as AboutModel).toMap(),
      'delivery_info': (deliveryInfo as DeliveryInfoModel).toMap(),
      'contact': (contact as ContactModel).toMap(),
      'opening_times': openingTimes,
    };
  }

  factory InfoModel.fromMap(Map<String, dynamic> map) {
    return InfoModel(
      about: AboutModel.fromMap(map['about'] as Map<String, dynamic>),
      deliveryInfo: DeliveryInfoModel.fromMap(
          map['delivery_info'] as Map<String, dynamic>),
      contact: ContactModel.fromMap(map['contact'] as Map<String, dynamic>),
      openingTimes: map['opening_times'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InfoModel.fromJson(String source) =>
      InfoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AboutModel extends AboutEntity {
  AboutModel({
    required super.informationId,
    required super.bottom,
    required super.sortOrder,
    required super.status,
    required super.languageId,
    required super.title,
    required super.description,
    required super.metaTitle,
    required super.metaDescription,
    required super.metaKeyword,
    required super.storeId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'information_id': informationId,
      'bottom': bottom,
      'sort_order': sortOrder,
      'status': status,
      'language_id': languageId,
      'title': title,
      'description': description,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'meta_keyword': metaKeyword,
      'store_id': storeId,
    };
  }

  factory AboutModel.fromMap(Map<String, dynamic> map) {
    return AboutModel(
      informationId: map['information_id'] as String,
      bottom: map['bottom'] as String,
      sortOrder: map['sort_order'] as String,
      status: map['status'] as String,
      languageId: map['language_id'] as String,
      title: map['title'] as String,
      description: (map['description'] ?? '') as String,
      metaTitle: map['meta_title'] as String,
      metaDescription: (map['meta_description'] ?? '') as String,
      metaKeyword: (map['meta_keyword'] ?? '') as String,
      storeId: map['store_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AboutModel.fromJson(String source) =>
      AboutModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class DeliveryInfoModel extends DeliveryInfoEntity {
  DeliveryInfoModel({
    required super.informationId,
    required super.bottom,
    required super.sortOrder,
    required super.status,
    required super.languageId,
    required super.title,
    required super.description,
    required super.metaTitle,
    required super.metaDescription,
    required super.metaKeyword,
    required super.storeId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'information_id': informationId,
      'bottom': bottom,
      'sort_order': sortOrder,
      'status': status,
      'language_id': languageId,
      'title': title,
      'description': description,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'meta_keyword': metaKeyword,
      'store_id': storeId,
    };
  }

  factory DeliveryInfoModel.fromMap(Map<String, dynamic> map) {
    return DeliveryInfoModel(
      informationId: map['information_id'] as String,
      bottom: map['bottom'] as String,
      sortOrder: map['sort_order'] as String,
      status: map['status'] as String,
      languageId: map['language_id'] as String,
      title: map['title'] as String,
      description: (map['description'] ?? '') as String,
      metaTitle: map['meta_title'] as String,
      metaDescription: (map['meta_description'] ?? '') as String,
      metaKeyword: (map['meta_keyword'] ?? '') as String,
      storeId: map['store_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryInfoModel.fromJson(String source) =>
      DeliveryInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ContactModel extends ContactEntity {
  ContactModel({
    required super.store,
    required super.address,
    required super.telephone,
    required super.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'store': store,
      'address': address,
      'telephone': telephone,
      'email': email,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      store: map['store'] as String,
      address: map['address'] as String,
      telephone: map['telephone'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
