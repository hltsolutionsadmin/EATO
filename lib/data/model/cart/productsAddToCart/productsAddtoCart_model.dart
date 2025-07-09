class ProductsAddToCartModel {
  ProductsAddToCartModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.cartId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? productId;
  final int? quantity;
  final dynamic price;
  final int? cartId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ProductsAddToCartModel.fromJson(Map<String, dynamic> json) {
    return ProductsAddToCartModel(
      id: json["id"],
      productId: json["productId"],
      quantity: json["quantity"],
      price: json["price"],
      cartId: json["cartId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }
}
