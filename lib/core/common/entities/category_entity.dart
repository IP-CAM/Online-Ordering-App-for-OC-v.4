
class CategoryEntity {
  final int categoryId;
  final String name;
  final String? description;
  final String? image;
  final int sortOrder;
  final bool status;
  final int productCount;
  final List<int>? products;
  final int parentId;

  CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.description,
    required this.image,
    required this.sortOrder,
    required this.status,
    required this.productCount,
    required this.products,
    required this.parentId,
  });

}
