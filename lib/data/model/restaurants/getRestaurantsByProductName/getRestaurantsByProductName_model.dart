class GetRestaurantsByProductNameModel {
  GetRestaurantsByProductNameModel({
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
  final num? number;
  final List<dynamic> sort;
  final bool? first;
  final num? numberOfElements;
  final bool? empty;

  factory GetRestaurantsByProductNameModel.fromJson(Map<String, dynamic> json) {
    return GetRestaurantsByProductNameModel(
      content: json["content"] == null
          ? []
          : List<Content>.from(
              json["content"]!.map((x) => Content.fromJson(x))),
      pageable:
          json["pageable"] == null ? null : Pageable.fromJson(json["pageable"]),
      last: json["last"],
      totalPages: json["totalPages"],
      totalElements: json["totalElements"],
      size: json["size"],
      number: json["number"],
      sort: json["sort"] == null
          ? []
          : List<dynamic>.from(json["sort"]!.map((x) => x)),
      first: json["first"],
      numberOfElements: json["numberOfElements"],
      empty: json["empty"],
    );
  }

  Map<String, dynamic> toJson() => {
        "content": content.map((x) => x?.toJson()).toList(),
        "pageable": pageable?.toJson(),
        "last": last,
        "totalPages": totalPages,
        "totalElements": totalElements,
        "size": size,
        "number": number,
        "sort": sort.map((x) => x).toList(),
        "first": first,
        "numberOfElements": numberOfElements,
        "empty": empty,
      };
}

class Content {
  Content({
    required this.id,
    required this.name,
    required this.shortCode,
    required this.ignoreTax,
    required this.discount,
    required this.description,
    required this.price,
    required this.available,
    required this.businessId,
    required this.businessName,
    required this.categoryId,
    required this.categoryName,
    required this.media,
    required this.attributes,
  });

  final int? id;
  final String? name;
  final String? shortCode;
  final bool? ignoreTax;
  final bool? discount;
  final String? description;
  final num? price;
  final bool? available;
  final int? businessId;
  final String? businessName;
  final int? categoryId;
  final String? categoryName;
  final List<Media> media;
  final List<Attribute> attributes;

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
      businessId: json["businessId"],
      businessName: json["businessName"],
      categoryId: json["categoryId"],
      categoryName: json["categoryName"],
      media: json["media"] == null
          ? []
          : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
      attributes: json["attributes"] == null
          ? []
          : List<Attribute>.from(
              json["attributes"]!.map((x) => Attribute.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "shortCode": shortCode,
        "ignoreTax": ignoreTax,
        "discount": discount,
        "description": description,
        "price": price,
        "available": available,
        "businessId": businessId,
        "businessName": businessName,
        "categoryId": categoryId,
        "categoryName": categoryName,
        "media": media.map((x) => x?.toJson()).toList(),
        "attributes": attributes.map((x) => x?.toJson()).toList(),
      };
}

class Attribute {
  Attribute({
    required this.id,
    required this.attributeName,
    required this.attributeValue,
  });

  final int? id;
  final String? attributeName;
  final String? attributeValue;

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json["id"],
      attributeName: json["attributeName"],
      attributeValue: json["attributeValue"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributeName": attributeName,
        "attributeValue": attributeValue,
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

  final List<dynamic> sort;
  final int? pageNumber;
  final int? pageSize;
  final int? offset;
  final bool? paged;
  final bool? unpaged;

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      sort: json["sort"] == null
          ? []
          : List<dynamic>.from(json["sort"]!.map((x) => x)),
      pageNumber: json["pageNumber"],
      pageSize: json["pageSize"],
      offset: json["offset"],
      paged: json["paged"],
      unpaged: json["unpaged"],
    );
  }

  Map<String, dynamic> toJson() => {
        "sort": sort.map((x) => x).toList(),
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "offset": offset,
        "paged": paged,
        "unpaged": unpaged,
      };
}
