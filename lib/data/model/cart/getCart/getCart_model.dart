class GetCartModel {
    GetCartModel({
        required this.id,
        required this.userId,
        required this.status,
        required this.cartItems,
        required this.businessId,
        required this.businessName,
        required this.totalCount,
        required this.createdAt,
        required this.updatedAt,
    });

    final int? id;
    final int? userId;
    final String? status;
    final List<CartItem> cartItems;
    final int? businessId;
    final String? businessName;
    final int? totalCount;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory GetCartModel.fromJson(Map<String, dynamic> json){ 
        return GetCartModel(
            id: json["id"],
            userId: json["userId"],
            status: json["status"],
            cartItems: json["cartItems"] == null ? [] : List<CartItem>.from(json["cartItems"]!.map((x) => CartItem.fromJson(x))),
            businessId: json["businessId"],
            businessName: json["businessName"],
            totalCount: json["totalCount"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
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
