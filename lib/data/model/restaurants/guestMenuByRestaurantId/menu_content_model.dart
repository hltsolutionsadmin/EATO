class Attribute {
  final int? id;
  final String? attributeName;
  final String? attributeValue;

  Attribute({
    required this.id,
    required this.attributeName,
    required this.attributeValue,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json["id"],
      attributeName: json["attributeName"],
      attributeValue: json["attributeValue"],
    );
  }
}

class Media {
  final String? mediaType;
  final String? url;

  Media({
    required this.mediaType,
    required this.url,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      mediaType: json["mediaType"],
      url: json["url"],
    );
  }
}

class Content {
  final int? id;
  final String? name;
  final String? shortCode;
  final bool? ignoreTax;
  final bool? discount;
  final String? description;
  final dynamic price;
  final bool? available;
  final String? shopifyProductId;
  final String? shopifyVariantId;
  final int? businessId;
  final int? categoryId;
  final String? categoryName;
  final String? businessName;
  final List<Media>? media;
  final List<Attribute> attributes;
  final String? status;

  Content({
    required this.id,
    required this.name,
    required this.shortCode,
    required this.ignoreTax,
    required this.discount,
    required this.description,
    required this.price,
    required this.available,
    this.shopifyProductId,
    this.shopifyVariantId,
    required this.businessId,
    required this.categoryId,
    this.categoryName,
    this.businessName,
    this.media,
    required this.attributes,
    this.status,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json["id"],
      name: json["name"],
      shortCode: json["shortCode"],
      ignoreTax: json["ignoreTax"],
      discount: json["discount"],
      description: json["description"],
      price: json["price"],
      available: json["available"],
      shopifyProductId: json["shopifyProductId"],
      shopifyVariantId: json["shopifyVariantId"],
      businessId: json["businessId"],
      businessName: json["businessName"],
      categoryId: json["categoryId"],
      categoryName: json["categoryName"],
      media: json["media"] == null
          ? []
          : List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
      attributes: json["attributes"] == null
          ? []
          : List<Attribute>.from(
              json["attributes"].map((x) => Attribute.fromJson(x))),
      status: json["status"],
    );
  }
}

class Pageable {
  final List<dynamic> sort;
  final int? pageNumber;
  final int? pageSize;
  final int? offset;
  final bool? paged;
  final bool? unpaged;

  Pageable({
    required this.sort,
    required this.pageNumber,
    required this.pageSize,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      sort: json["sort"] == null
          ? []
          : List<dynamic>.from(json["sort"].map((x) => x)),
      pageNumber: json["pageNumber"],
      pageSize: json["pageSize"],
      offset: json["offset"],
      paged: json["paged"],
      unpaged: json["unpaged"],
    );
  }
}
