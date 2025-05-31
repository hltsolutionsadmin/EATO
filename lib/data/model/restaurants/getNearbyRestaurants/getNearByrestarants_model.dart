class GetNearByRestaurantsModel {
  GetNearByRestaurantsModel({
    required this.content,
    required this.pageable,
    required this.totalPages,
    required this.totalElements,
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
  final int? totalPages;
  final int? totalElements;
  final bool? last;
  final int? size;
  final int? number;
  final List<dynamic> sort;
  final int? numberOfElements;
  final bool? first;
  final bool? empty;

  factory GetNearByRestaurantsModel.fromJson(Map<String, dynamic> json) {
    return GetNearByRestaurantsModel(
      content: json["content"] == null
          ? []
          : List<Content>.from(
              json["content"]!.map((x) => Content.fromJson(x))),
      pageable:
          json["pageable"] == null ? null : Pageable.fromJson(json["pageable"]),
      totalPages: json["totalPages"],
      totalElements: json["totalElements"],
      last: json["last"],
      size: json["size"],
      number: json["number"],
      sort: json["sort"] == null
          ? []
          : List<dynamic>.from(json["sort"]!.map((x) => x)),
      numberOfElements: json["numberOfElements"],
      first: json["first"],
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
    required this.addressDto,
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
  final AddressDto? addressDto;
  final List<Attribute> attributes;

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json["id"],
      businessName: json["businessName"],
      approved: json["approved"],
      enabled: json["enabled"],
      businessLatitude: json["businessLatitude"],
      businessLongitude: json["businessLongitude"],
      categoryName: json["categoryName"],
      creationDate: DateTime.tryParse(json["creationDate"] ?? ""),
      userDto:
          json["userDTO"] == null ? null : UserDto.fromJson(json["userDTO"]),
      addressDto: json["addressDTO"] == null
          ? null
          : AddressDto.fromJson(json["addressDTO"]),
      attributes: json["attributes"] == null
          ? []
          : List<Attribute>.from(
              json["attributes"]!.map((x) => Attribute.fromJson(x))),
    );
  }
}

class AddressDto {
  AddressDto({
    required this.id,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.postalCode,
  });

  final int? id;
  final String? addressLine1;
  final String? city;
  final String? state;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? postalCode;

  factory AddressDto.fromJson(Map<String, dynamic> json) {
    return AddressDto(
      id: json["id"],
      addressLine1: json["addressLine1"],
      city: json["city"],
      state: json["state"],
      country: json["country"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      postalCode: json["postalCode"],
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

  factory Attribute.fromJson(Map<String, dynamic> json) {
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
    required this.roles,
    required this.fcmToken,
  });

  final int? id;
  final String? fullName;
  final String? primaryContact;
  final DateTime? recentActivityDate;
  final List<String> roles;
  final String? fcmToken;

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json["id"],
      fullName: json["fullName"],
      primaryContact: json["primaryContact"],
      recentActivityDate: DateTime.tryParse(json["recentActivityDate"] ?? ""),
      roles: json["roles"] == null
          ? []
          : List<String>.from(json["roles"]!.map((x) => x)),
      fcmToken: json["fcmToken"],
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
}
