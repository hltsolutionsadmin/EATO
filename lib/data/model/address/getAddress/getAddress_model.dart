class GetAddressModel {
    GetAddressModel({
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

    factory GetAddressModel.fromJson(Map<String, dynamic> json){ 
        return GetAddressModel(
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
    });

    final int? id;
    final String? addressLine1;
    final String? addressLine2;
    final String? street;
    final String? city;
    final String? state;
    final String? country;
    final double? latitude;
    final double? longitude;
    final String? postalCode;
    final int? userId;

    factory Content.fromJson(Map<String, dynamic> json){ 
        return Content(
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
