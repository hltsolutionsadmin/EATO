class SaveAddressModel {
    SaveAddressModel({
        required this.id,
        required this.userId,
        required this.status,
        required this.shopifyCartId,
        required this.cartItems,
        required this.createdAt,
        required this.updatedAt,
        required this.shippingAddressId,
    });

    final int? id;
    final int? userId;
    final String? status;
    final String? shopifyCartId;
    final List<CartItem> cartItems;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? shippingAddressId;

    factory SaveAddressModel.fromJson(Map<String, dynamic> json){ 
        return SaveAddressModel(
            id: json["id"],
            userId: json["userId"],
            status: json["status"],
            shopifyCartId: json["shopifyCartId"],
            cartItems: json["cartItems"] == null ? [] : List<CartItem>.from(json["cartItems"]!.map((x) => CartItem.fromJson(x))),
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            shippingAddressId: json["shippingAddressId"],
        );
    }

}

class CartItem {
    CartItem({
        required this.id,
        required this.productId,
        required this.quantity,
        required this.price,
        required this.cartId,
        required this.createdAt,
    });

    final int? id;
    final int? productId;
    final int? quantity;
    final double? price;
    final int? cartId;
    final DateTime? createdAt;

    factory CartItem.fromJson(Map<String, dynamic> json){ 
        return CartItem(
            id: json["id"],
            productId: json["productId"],
            quantity: json["quantity"],
            price: json["price"],
            cartId: json["cartId"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
        );
    }

}
