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
    this.shippingAddressId, // Make shippingAddressId nullable
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
  final int? shippingAddressId; // Add shippingAddressId

  factory GetCartModel.fromJson(Map<String, dynamic> json) {
    return GetCartModel(
      id: json["id"],
      userId: json["userId"],
      status: json["status"],
      cartItems: json["cartItems"] == null
          ? []
          : List<CartItem>.from(
              json["cartItems"]!.map((x) => CartItem.fromJson(x))),
      businessId: json["businessId"],
      businessName: json["businessName"],
      totalCount: json["totalCount"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      shippingAddressId: json["shippingAddressId"], // Parse shippingAddressId
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "status": status,
      "cartItems": cartItems.map((x) => x.toJson()).toList(),
      "businessId": businessId,
      "businessName": businessName,
      "totalCount": totalCount,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "shippingAddressId": shippingAddressId,
    };
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
    required this.productName,
    this.media,
  });

  final int? id;
  final int? productId;
  final int? quantity;
  final double? price;
  final int? cartId;
  final DateTime? createdAt;
  final String? productName;
  final List<Media>? media; // List of Media for a cart item

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json["id"],
      productId: json["productId"],
      quantity: json["quantity"],
      price: json["price"]?.toDouble(), // Ensure price is double
      cartId: json["cartId"],
      productName: json["productName"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      media: json["media"] == null
          ? []
          : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productId": productId,
      "quantity": quantity,
      "price": price,
      "cartId": cartId,
      "createdAt": createdAt?.toIso8601String(),
      "productName": productName,
      "media": media?.map((x) => x.toJson()).toList(),
    };
  }
}

class Media {
  Media({
    this.mediaType,
    this.url,
  });

  final String? mediaType;
  final String? url;

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mediaType: json["mediaType"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mediaType": mediaType,
      "url": url,
    };
  }
}