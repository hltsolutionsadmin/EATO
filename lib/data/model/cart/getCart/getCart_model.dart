class GetCartModel {
  int? id;
  int? userId;
  String? status;
  List<CartItems>? cartItems;
  int? businessId;
  String? businessName;
  int? totalCount;
  String? createdAt;
  String? updatedAt;

  GetCartModel(
      {this.id,
      this.userId,
      this.status,
      this.cartItems,
      this.businessId,
      this.businessName,
      this.totalCount,
      this.createdAt,
      this.updatedAt});

  GetCartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    status = json['status'];
    cartItems = <CartItems>[];
  if (json['cartItems'] != null) {
    json['cartItems']?.forEach((v) {
      cartItems?.add(CartItems.fromJson(v));
    });
  }
    businessId = json['businessId'];
    businessName = json['businessName'];
    totalCount = json['totalCount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['status'] = status;
    if (cartItems != null) {
      data['cartItems'] = cartItems!.map((v) => v.toJson()).toList();
    }
    data['businessId'] = businessId;
    data['businessName'] = businessName;
    data['totalCount'] = totalCount;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class CartItems {
  int? id;
  int? productId;
  String? productName;
  int? quantity;
  double? price;
  int? cartId;
  String? createdAt;

  CartItems(
      {this.id,
      this.productId,
      this.productName,
      this.quantity,
      this.price,
      this.cartId,
      this.createdAt});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    productName = json['productName'];
    quantity = json['quantity'];
    price = json['price'];
    cartId = json['cartId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productId'] = productId;
    data['productName'] = productName;
    data['quantity'] = quantity;
    data['price'] = price;
    data['cartId'] = cartId;
    data['createdAt'] = createdAt;
    return data;
  }
}
