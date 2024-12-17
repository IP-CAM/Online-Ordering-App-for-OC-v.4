import 'dart:convert';

import 'package:ordering_app/features/home/domain/entities/home_banner_entity.dart';

class HomeBannerModel extends HomeBannerEntity {
  HomeBannerModel({
    required super.moduleId,
    required super.name,
    required super.width,
    required super.height,
    required super.effect,
    required super.controls,
    required super.indicators,
    required super.items,
    required super.interval,
    required super.slides,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'module_id': moduleId,
      'name': name,
      'width': width,
      'height': height,
      'effect': effect,
      'controls': controls,
      'indicators': indicators,
      'items': items,
      'interval': interval,
      'slides': slides.map((x) => (x as SlideModel).toMap()).toList(),
    };
  }

  factory HomeBannerModel.fromMap(Map<String, dynamic> map) {
    return HomeBannerModel(
      moduleId: map['module_id'] as int,
      name: map['name'] as String,
      width: map['width'] as int,
      height: map['height'] as int,
      effect: map['effect'] as String,
      controls: map['controls'] as String,
      indicators: map['indicators'] as String,
      items: map['items'] as String,
      interval: map['interval'] as int,
      slides: List<SlideEntity>.from(
        (map['slides'] as List).map<SlideEntity>(
          (x) => SlideModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeBannerModel.fromJson(String source) =>
      HomeBannerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SlideModel extends SlideEntity {
  SlideModel({
    required super.title,
    required super.link,
    required super.image,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'link': link,
      'image': image,
    };
  }

  factory SlideModel.fromMap(Map<String, dynamic> map) {
    return SlideModel(
      title: map['title'] as String,
      link: map['link'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SlideModel.fromJson(String source) => SlideModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
