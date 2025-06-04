class CreateOrderModel {
    CreateOrderModel({
        required this.message,
        required this.status,
        required this.data,
    });

    final String? message;
    final String? status;
    final Data? data;

    factory CreateOrderModel.fromJson(Map<String, dynamic> json){ 
        return CreateOrderModel(
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
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

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
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
            orderItems: json["orderItems"] == null ? [] : List<OrderItem>.from(json["orderItems"]!.map((x) => OrderItem.fromJson(x))),
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

    factory OrderItem.fromJson(Map<String, dynamic> json){ 
        return OrderItem(
            id: json["id"],
            productId: json["productId"],
            quantity: json["quantity"],
            price: json["price"],
            entryNumber: json["entryNumber"],
        );
    }

}
