class GetNearByRestaurantsModel {
    GetNearByRestaurantsModel({
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

    factory GetNearByRestaurantsModel.fromJson(Map<String, dynamic> json){ 
        return GetNearByRestaurantsModel(
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
        required this.businessName,
        required this.approved,
        required this.enabled,
        required this.businessLatitude,
        required this.businessLongitude,
        required this.categoryName,
        required this.creationDate,
        required this.userDto,
        required this.attributes,
    });

    final int? id;
    final String? businessName;
    final bool? approved;
    final bool? enabled;
    final double? businessLatitude;
    final double? businessLongitude;
    final String? categoryName;
    final DateTime? creationDate;
    final UserDto? userDto;
    final List<Attribute> attributes;

    factory Content.fromJson(Map<String, dynamic> json){ 
        return Content(
            id: json["id"],
            businessName: json["businessName"],
            approved: json["approved"],
            enabled: json["enabled"],
            businessLatitude: json["businessLatitude"],
            businessLongitude: json["businessLongitude"],
            categoryName: json["categoryName"],
            creationDate: DateTime.tryParse(json["creationDate"] ?? ""),
            userDto: json["userDTO"] == null ? null : UserDto.fromJson(json["userDTO"]),
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

class UserDto {
    UserDto({
        required this.id,
        required this.fullName,
        required this.primaryContact,
        required this.recentActivityDate,
        required this.addresses,
        required this.roles,
    });

    final int? id;
    final String? fullName;
    final String? primaryContact;
    final DateTime? recentActivityDate;
    final List<Address> addresses;
    final List<String> roles;

    factory UserDto.fromJson(Map<String, dynamic> json){ 
        return UserDto(
            id: json["id"],
            fullName: json["fullName"],
            primaryContact: json["primaryContact"],
            recentActivityDate: DateTime.tryParse(json["recentActivityDate"] ?? ""),
            addresses: json["addresses"] == null ? [] : List<Address>.from(json["addresses"]!.map((x) => Address.fromJson(x))),
            roles: json["roles"] == null ? [] : List<String>.from(json["roles"]!.map((x) => x)),
        );
    }

}

class Address {
    Address({
        required this.id,
        required this.addressLine1,
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
    final String? street;
    final String? city;
    final String? state;
    final String? country;
    final double? latitude;
    final double? longitude;
    final String? postalCode;
    final int? userId;

    factory Address.fromJson(Map<String, dynamic> json){ 
        return Address(
            id: json["id"],
            addressLine1: json["addressLine1"],
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
