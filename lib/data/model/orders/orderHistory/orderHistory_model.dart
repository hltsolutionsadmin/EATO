class OrderHistoryModel {
  OrderHistoryModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final String? status;
  final Data? data;

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    required this.content,
    required this.pageable,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.size,
    required this.number,
    required this.sort,
    required this.numberOfElements,
    required this.first,
    required this.empty,
  });

  final List<Content> content;
  final Pageable? pageable;
  final int? totalElements;
  final int? totalPages;
  final bool? last;
  final int? size;
  final int? number;
  final List<Sort> sort;
  final int? numberOfElements;
  final bool? first;
  final bool? empty;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      content: json["content"] == null
          ? []
          : List<Content>.from(
              json["content"]!.map((x) => Content.fromJson(x))),
      pageable:
          json["pageable"] == null ? null : Pageable.fromJson(json["pageable"]),
      totalElements: json["totalElements"],
      totalPages: json["totalPages"],
      last: json["last"],
      size: json["size"],
      number: json["number"],
      sort: json["sort"] == null
          ? []
          : List<Sort>.from(json["sort"]!.map((x) => Sort.fromJson(x))),
      numberOfElements: json["numberOfElements"],
      first: json["first"],
      empty: json["empty"],
    );
  }

  Map<String, dynamic> toJson() => {
        "content": content.map((x) => x.toJson()).toList(),
        "pageable": pageable?.toJson(),
        "totalElements": totalElements,
        "totalPages": totalPages,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort.map((x) => x.toJson()).toList(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
      };
}

class Content {
  Content({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.username,
    required this.mobileNumber,
    required this.address,
    required this.businessId,
    required this.businessName,
    required this.shippingAddressId,
    required this.totalAmount,
    required this.totalTaxAmount,
    required this.taxInclusive,
    required this.paymentStatus,
    required this.paymentTransactionId,
    required this.orderStatus,
    required this.createdDate,
    required this.updatedDate,
    required this.orderItems,
  });

  final int? id;
  final String? orderNumber;
  final int? userId;
  final String? username;
  final String? mobileNumber;
  final Address? address;
  final int? businessId;
  final String? businessName;
  final int? shippingAddressId;
  final num? totalAmount;
  final num? totalTaxAmount;
  final bool? taxInclusive;
  final String? paymentStatus;
  final String? paymentTransactionId;
  final String? orderStatus;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final List<OrderItem> orderItems;

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json["id"],
      orderNumber: json["orderNumber"],
      userId: json["userId"],
      username: json["username"],
      mobileNumber: json["mobileNumber"],
      address:
          json["address"] == null ? null : Address.fromJson(json["address"]),
      businessId: json["businessId"],
      businessName: json["businessName"],
      shippingAddressId: json["shippingAddressId"],
      totalAmount: json["totalAmount"],
      totalTaxAmount: json["totalTaxAmount"],
      taxInclusive: json["taxInclusive"],
      paymentStatus: json["paymentStatus"],
      paymentTransactionId: json["paymentTransactionId"],
      orderStatus: json["orderStatus"],
      createdDate: DateTime.tryParse(json["createdDate"] ?? ""),
      updatedDate: DateTime.tryParse(json["updatedDate"] ?? ""),
      orderItems: json["orderItems"] == null
          ? []
          : List<OrderItem>.from(
              json["orderItems"]!.map((x) => OrderItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderNumber": orderNumber,
        "userId": userId,
        "username": username,
        "mobileNumber": mobileNumber,
        "address": address?.toJson(),
        "businessId": businessId,
        "businessName": businessName,
        "shippingAddressId": shippingAddressId,
        "totalAmount": totalAmount,
        "totalTaxAmount": totalTaxAmount,
        "taxInclusive": taxInclusive,
        "paymentStatus": paymentStatus,
        "paymentTransactionId": paymentTransactionId,
        "orderStatus": orderStatus,
        "createdDate": createdDate?.toIso8601String(),
        "updatedDate": updatedDate?.toIso8601String(),
        "orderItems": orderItems.map((x) => x.toJson()).toList(),
      };
}

class Address {
  Address({
    required this.id,
    required this.addressLine1,
    required this.addressLine2,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.postalCode,
    required this.userId,
    required this.isDefault,
  });

  final int? id;
  final String? addressLine1;
  final String? addressLine2;
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final num? latitude;
  final num? longitude;
  final String? postalCode;
  final int? userId;
  final bool? isDefault;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json["id"],
      addressLine1: json["addressLine1"],
      addressLine2: json["addressLine2"],
      street: json["street"],
      city: json["city"],
      state: json["state"],
      country: json["country"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      postalCode: json["postalCode"],
      userId: json["userId"],
      isDefault: json["isDefault"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "street": street,
        "city": city,
        "state": state,
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
        "postalCode": postalCode,
        "userId": userId,
        "isDefault": isDefault,
      };
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
    required this.taxAmount,
    required this.taxPercentage,
    required this.totalAmount,
    required this.taxIgnored,
  });

  final int? id;
  final int? productId;
  final int? quantity;
  final num? price;
  final int? entryNumber;
  final String? productName;
  final List<Media> media;
  final num? taxAmount;
  final int? taxPercentage;
  final num? totalAmount;
  final bool? taxIgnored;

factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: (json["id"] as num?)?.toInt(),
      productId: (json["productId"] as num?)?.toInt(),
      quantity: (json["quantity"] as num?)?.toInt(),
      price: json["price"],
      entryNumber: (json["entryNumber"] as num?)?.toInt(),
      productName: json["productName"],
      media: json["media"] == null
          ? []
          : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
      taxAmount: json["taxAmount"],
      taxPercentage: (json["taxPercentage"] as num?)?.toInt(),
      totalAmount: json["totalAmount"],
      taxIgnored: json["taxIgnored"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "quantity": quantity,
        "price": price,
        "entryNumber": entryNumber,
        "productName": productName,
        "media": media.map((x) => x.toJson()).toList(),
        "taxAmount": taxAmount,
        "taxPercentage": taxPercentage,
        "totalAmount": totalAmount,
        "taxIgnored": taxIgnored,
      };
}

class Media {
  Media({
    required this.mediaType,
    required this.url,
  });

  final String? mediaType;
  final String? url;

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mediaType: json["mediaType"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "mediaType": mediaType,
        "url": url,
      };
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
  final num? offset;
  final bool? paged;
  final bool? unpaged;

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      sort: json["sort"] == null
          ? []
          : List<Sort>.from(json["sort"]!.map((x) => Sort.fromJson(x))),
      pageNumber: json["pageNumber"],
      pageSize: json["pageSize"],
      offset: json["offset"],
      paged: json["paged"],
      unpaged: json["unpaged"],
    );
  }

  Map<String, dynamic> toJson() => {
        "sort": sort.map((x) => x.toJson()).toList(),
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "offset": offset,
        "paged": paged,
        "unpaged": unpaged,
      };
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
      direction: json["direction"],
      property: json["property"],
      ignoreCase: json["ignoreCase"],
      nullHandling: json["nullHandling"],
      ascending: json["ascending"],
      descending: json["descending"],
    );
  }

  Map<String, dynamic> toJson() => {
        "direction": direction,
        "property": property,
        "ignoreCase": ignoreCase,
        "nullHandling": nullHandling,
        "ascending": ascending,
        "descending": descending,
      };
}
