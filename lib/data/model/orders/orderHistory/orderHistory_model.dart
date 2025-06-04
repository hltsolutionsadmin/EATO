class OrderHistoryModel {
  OrderHistoryModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final String? status;
  final List<Datum> data;

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.shippingAddressId,
    required this.totalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    required this.paymentTransactionId,
    required this.orderItems,
    required this.createdDate,
    required this.updatedDate,
  });

  final int? id;
  final String? orderNumber;
  final int? userId;
  final int? restaurantId;
  final String? restaurantName;
  final dynamic shippingAddressId;
  final double? totalAmount;
  final String? paymentStatus;
  final String? orderStatus;
  final dynamic paymentTransactionId;
  final List<OrderItem> orderItems;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"],
      orderNumber: json["orderNumber"],
      userId: json["userId"],
      restaurantId: json["restaurantId"],
      restaurantName: json["restaurantName"],
      shippingAddressId: json["shippingAddressId"],
      totalAmount: json["totalAmount"],
      paymentStatus: json["paymentStatus"],
      orderStatus: json["orderStatus"],
      paymentTransactionId: json["paymentTransactionId"],
      orderItems: json["orderItems"] == null
          ? []
          : List<OrderItem>.from(
              json["orderItems"]!.map((x) => OrderItem.fromJson(x))),
      createdDate: DateTime.tryParse(json["createdDate"] ?? ""),
      updatedDate: DateTime.tryParse(json["updatedDate"] ?? ""),
    );
  }
}

class OrderItem {
  OrderItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.entryNumber,
  });

  final int? id;
  final int? productId;
  final int? quantity;
  final double? price;
  final int? entryNumber;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json["id"],
      productId: json["productId"],
      quantity: json["quantity"],
      price: json["price"],
      entryNumber: json["entryNumber"],
    );
  }
}
