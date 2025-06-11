import 'dart:convert';

class OrderHistoryModel {
  OrderHistoryModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final String? status;
  final Data? data;

  factory OrderHistoryModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return OrderHistoryModel(
        message: json["message"] as String?,
        status: json["status"] as String?,
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
    } else if (json is String) {
      try {
        final parsedJson = jsonDecode(json);
        return OrderHistoryModel.fromJson(parsedJson);
      } catch (e) {
        throw Exception("Failed to parse JSON string: $e");
      }
    }
    throw Exception("Invalid JSON type: ${json.runtimeType}");
  }
}

class Data {
  Data({
    required this.content,
    required this.pageable,
    required this.last,
    required this.totalPages,
    required this.totalElements,
    required this.size,
    required this.number,
    required this.sort,
    required this.first,
    required this.numberOfElements,
    required this.empty,
  });

  final List<Content> content;
  final Pageable? pageable;
  final bool? last;
  final int? totalPages;
  final int? totalElements;
  final int? size;
  final int? number;
  final List<Sort> sort;
  final bool? first;
  final int? numberOfElements;
  final bool? empty;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      content: json["content"] == null
          ? []
          : List<Content>.from(
              json["content"]!.map((x) => Content.fromJson(x))),
      pageable:
          json["pageable"] == null ? null : Pageable.fromJson(json["pageable"]),
      last: json["last"] as bool?,
      totalPages: json["totalPages"] as int?,
      totalElements: json["totalElements"] as int?,
      size: json["size"] as int?,
      number: json["number"] as int?,
      sort: json["sort"] == null
          ? []
          : List<Sort>.from(json["sort"]!.map((x) => Sort.fromJson(x))),
      first: json["first"] as bool?,
      numberOfElements: json["numberOfElements"] as int?,
      empty: json["empty"] as bool?,
    );
  }
}

class Content {
  Content({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.businessId,
    required this.businessName,
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
  final int? businessId;
  final String? businessName;
  final int? shippingAddressId;
  final double? totalAmount;
  final String? paymentStatus;
  final String? orderStatus;
  final dynamic paymentTransactionId;
  final List<OrderItem> orderItems;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json["id"] as int?,
      orderNumber: json["orderNumber"] as String?,
      userId: json["userId"] as int?,
      businessId: json["businessId"] as int?,
      businessName: json["businessName"] as String?,
      shippingAddressId: json["shippingAddressId"] as int?,
      totalAmount: json["totalAmount"]?.toDouble(),
      paymentStatus: json["paymentStatus"] as String?,
      orderStatus: json["orderStatus"] as String?,
      paymentTransactionId: json["paymentTransactionId"],
      orderItems: json["orderItems"] == null
          ? []
          : List<OrderItem>.from(
              json["orderItems"]!.map((x) => OrderItem.fromJson(x))),
      createdDate: json["createdDate"] == null
          ? null
          : DateTime.tryParse(json["createdDate"].toString()),
      updatedDate: json["updatedDate"] == null
          ? null
          : DateTime.tryParse(json["updatedDate"].toString()),
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
    required this.productName,
    required this.media,
  });

  final int? id;
  final int? productId;
  final int? quantity;
  final double? price;
  final int? entryNumber;
  final String? productName;
  final dynamic media;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json["id"] as int?,
      productId: json["productId"] as int?,
      quantity: json["quantity"] as int?,
      price: json["price"]?.toDouble(),
      entryNumber: json["entryNumber"] as int?,
      productName: json["productName"] as String?,
      media: json["media"],
    );
  }
}

class Pageable {
  Pageable({
    required this.sort,
    required this.pageNumber,
    required this.pageSize,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  final List<Sort> sort;
  final int? pageNumber;
  final int? pageSize;
  final int? offset;
  final bool? paged;
  final bool? unpaged;

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      sort: json["sort"] == null
          ? []
          : List<Sort>.from(json["sort"]!.map((x) => Sort.fromJson(x))),
      pageNumber: json["pageNumber"] as int?,
      pageSize: json["pageSize"] as int?,
      offset: json["offset"] as int?,
      paged: json["paged"] as bool?,
      unpaged: json["unpaged"] as bool?,
    );
  }
}

class Sort {
  Sort({
    required this.direction,
    required this.property,
    required this.ignoreCase,
    required this.nullHandling,
    required this.ascending,
    required this.descending,
  });

  final String? direction;
  final String? property;
  final bool? ignoreCase;
  final String? nullHandling;
  final bool? ascending;
  final bool? descending;

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      direction: json["direction"] as String?,
      property: json["property"] as String?,
      ignoreCase: json["ignoreCase"] as bool?,
      nullHandling: json["nullHandling"] as String?,
      ascending: json["ascending"] as bool?,
      descending: json["descending"] as bool?,
    );
  }
}
