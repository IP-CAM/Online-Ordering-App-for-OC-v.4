import 'dart:convert';

import 'package:ordering_app/features/address_book/data/models/address_model.dart';
import 'package:ordering_app/features/checkout/data/models/payment_method_model.dart';
import 'package:ordering_app/features/checkout/data/models/shipping_method_model.dart';
import 'package:ordering_app/features/checkout/domain/entities/checkout_summary_entity.dart';

class CheckoutSummaryModel extends CheckoutSummaryEntity {
  CheckoutSummaryModel({
    required super.checkoutTotals,
    required super.shippingAddress,
    required super.shippingMethod,
    required super.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'checkoutTotals': (checkoutTotals as CheckoutTotalsModel).toMap(),
      'shippingAddress': (shippingAddress as AddressModel).toMap(),
      'shippingMethod': (shippingMethod as ShippingMethodModel).toMap(),
      'paymentMethod': (paymentMethod as PaymentMethodModel).toMap(),
    };
  }

  factory CheckoutSummaryModel.fromMap(Map<String, dynamic> map) {
    return CheckoutSummaryModel(
      checkoutTotals:
          CheckoutTotalsModel.fromMap(map['totals'] as Map<String, dynamic>),
      shippingAddress:
          AddressModel.fromMap(map['shipping_address'] as Map<String, dynamic>),
      shippingMethod: ShippingMethodModel.fromMap(
          map['shipping_method'] as Map<String, dynamic>),
      paymentMethod: PaymentMethodModel.fromMap(
          map['payment_method'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckoutSummaryModel.fromJson(String source) =>
      CheckoutSummaryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CheckoutTotalsModel extends CheckoutTotals {
  CheckoutTotalsModel({
    required super.subTotal,
    required super.total,
    required super.appliedTotals,
    required super.taxes,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subTotal': subTotal,
      'total': total,
      'appliedTotals': appliedTotals.map((x) => (x as AppliedTotalModel).toMap()).toList(),
      'taxes': taxes.map((x) => (x as TaxModel).toMap()).toList(),
    };
  }

  factory CheckoutTotalsModel.fromMap(Map<String, dynamic> map) {
    return CheckoutTotalsModel(
      subTotal: map['subtotal'] as String,
      total: map['total'] as String,
      appliedTotals: List<AppliedTotalModel>.from((map['applied_totals'] as List<dynamic>).map<AppliedTotalModel>((x) => AppliedTotalModel.fromMap(x as Map<String,dynamic>),),),
      taxes: List<TaxModel>.from((map['taxes'] as List<dynamic>).map<TaxEntity>((x) => TaxModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckoutTotalsModel.fromJson(String source) => CheckoutTotalsModel.fromMap(json.decode(source) as Map<String, dynamic>);

}

class TaxModel extends TaxEntity {
  TaxModel({
    required super.code,
    required super.title,
    required super.value,
    required super.sortOrder,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'title': title,
      'value': value,
      'sort_order': sortOrder,
    };
  }

  factory TaxModel.fromMap(Map<String, dynamic> map) {
    return TaxModel(
      code: map['code'] as String,
      title: map['title'] as String,
      value: map['value'] is double
          ? map['value'] as double
          : map['value'] is int
              ? (map['value'] as int).toDouble()
              : double.tryParse(map['value'].toString()) ?? 0.0,
      sortOrder: map['sort_order'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaxModel.fromJson(String source) =>
      TaxModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AppliedTotalModel extends AppliedTotalEntity{
  AppliedTotalModel({required super.title, required super.value,});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'value': value,
    };
  }

  factory AppliedTotalModel.fromMap(Map<String, dynamic> map) {
    return AppliedTotalModel(
      title: map['title'] as String,
      value: map['value'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppliedTotalModel.fromJson(String source) => AppliedTotalModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
