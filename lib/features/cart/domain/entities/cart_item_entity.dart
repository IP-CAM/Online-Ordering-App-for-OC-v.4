class CartItemEntity {
  final int cartId;
  final int productId;
  final String name;
  final String model;
  final List<CartItemOptionEntity>? options;
  final String? subscription;
  final int quantity;
  final String price;
  final String total;
  final String? image;

  const CartItemEntity({
    required this.cartId,
    required this.productId,
    required this.name,
    required this.model,
    required this.options,
    required this.subscription,
    required this.quantity,
    required this.price,
    required this.total,
    required this.image,
  });

  
}

class CartItemOptionEntity {
  final String productOptionId;
  final String? productOptionValueId;
  final String name;
  final String value;

  const CartItemOptionEntity({
    required this.productOptionId,
    required this.productOptionValueId,
    required this.name,
    required this.value,
  });


}
