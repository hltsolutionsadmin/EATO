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
    final int? number;
    final List<dynamic> sort;
    final bool? first;
    final int? numberOfElements;
    final bool? empty;

    factory GetRestaurantsByProductNameModel.fromJson(Map<String, dynamic> json){ 
        return GetRestaurantsByProductNameModel(
            content: json["content"] == null ? [] : List<Content>.from(json["content"]!.map((x) => Content.fromJson(x))),
            pageable: json["pageable"] == null ? null : Pageable.fromJson(json["pageable"]),
            last: json["last"],
            totalPages: json["totalPages"],
            totalElements: json["totalElements"],
            size: json["size"],
            number: json["number"],
            sort: json["sort"] == null ? [] : List<dynamic>.from(json["sort"]!.map((x) => x)),
            first: json["first"],
            numberOfElements: json["numberOfElements"],
            empty: json["empty"],
        );
    }

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
    final double? price;
    final bool? available;
    final int? businessId;
    final int? categoryId;
    final String? categoryName;
    final List<dynamic> media;
    final List<Attribute> attributes;

    factory Content.fromJson(Map<String, dynamic> json){ 
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
            categoryId: json["categoryId"],
            categoryName: json["categoryName"],
            media: json["media"] == null ? [] : List<dynamic>.from(json["media"]!.map((x) => x)),
            attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
        );
    }

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

    factory Attribute.fromJson(Map<String, dynamic> json){ 
        return Attribute(
            id: json["id"],
            attributeName: json["attributeName"],
            attributeValue: json["attributeValue"],
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

    final List<dynamic> sort;
    final int? pageNumber;
    final int? pageSize;
    final int? offset;
    final bool? paged;
    final bool? unpaged;

    factory Pageable.fromJson(Map<String, dynamic> json){ 
        return Pageable(
            sort: json["sort"] == null ? [] : List<dynamic>.from(json["sort"]!.map((x) => x)),
            pageNumber: json["pageNumber"],
            pageSize: json["pageSize"],
            offset: json["offset"],
            paged: json["paged"],
            unpaged: json["unpaged"],
        );
    }

}
