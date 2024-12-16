class ProductOptionEntity {
  final String productOptionId;
  final String optionId;
  final String name;
  final String type;
  final List<ProductOptionValueEntity> optionValue;
  final String required;
  final String defaultValue;
  final String masterOption;
  final String masterOptionValue;
  final String minimum;
  final String maximum;

  const ProductOptionEntity({
    required this.productOptionId,
    required this.optionId,
    required this.name,
    required this.type,
    required this.optionValue,
    required this.required,
    required this.defaultValue,
    required this.masterOption,
    required this.masterOptionValue,
    required this.minimum,
    required this.maximum,
  });
}

class ProductOptionValueEntity {
  final String productOptionValueId;
  final String optionValueId;
  final String name;
  final String shortcode;
  final bool price;
  final String pricePrefix;
  final double priceValue;
  final String masterOptionValue;

  const ProductOptionValueEntity({
    required this.productOptionValueId,
    required this.optionValueId,
    required this.name,
    required this.shortcode,
    required this.price,
    required this.pricePrefix,
    required this.priceValue,
    required this.masterOptionValue,
  });

}
