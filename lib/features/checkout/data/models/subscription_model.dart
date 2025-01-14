import 'dart:convert';

import 'package:ordering_app/features/checkout/domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  SubscriptionModel({
    required super.subscriptionPlanId,
    required super.name,
    required super.price,
    required super.frequency,
    required super.duration,
  });

    Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subscriptionPlanId': subscriptionPlanId,
      'name': name,
      'price': price,
      'frequency': frequency,
      'duration': duration,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      subscriptionPlanId: map['subscription_plan_id'] as String,
      name: map['name'] as String,
      price: map['price'] as String,
      frequency: map['frequency'] as String,
      duration: map['duration'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionModel.fromJson(String source) => SubscriptionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}