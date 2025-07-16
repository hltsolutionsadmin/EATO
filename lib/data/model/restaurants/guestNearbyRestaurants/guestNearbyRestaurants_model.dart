class GuestNearByRestaurantsModel {
    GuestNearByRestaurantsModel({
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
    final List<dynamic> sort;
    final int? numberOfElements;
    final bool? first;
    final bool? empty;

    factory GuestNearByRestaurantsModel.fromJson(Map<String, dynamic> json){ 
        return GuestNearByRestaurantsModel(
            content: json["content"] == null ? [] : List<Content>.from(json["content"]!.map((x) => Content.fromJson(x))),
            pageable: json["pageable"] == null ? null : Pageable.fromJson(json["pageable"]),
            totalElements: json["totalElements"],
            totalPages: json["totalPages"],
            last: json["last"],
            size: json["size"],
            number: json["number"],
            sort: json["sort"] == null ? [] : List<dynamic>.from(json["sort"]!.map((x) => x)),
            numberOfElements: json["numberOfElements"],
            first: json["first"],
            empty: json["empty"],
        );
    }

    Map<String, dynamic> toJson() => {
        "content": content.map((x) => x?.toJson()).toList(),
        "pageable": pageable?.toJson(),
        "totalElements": totalElements,
        "totalPages": totalPages,
        "last": last,
        "size": size,
        "number": number,
        "sort": sort.map((x) => x).toList(),
        "numberOfElements": numberOfElements,
        "first": first,
        "empty": empty,
    };

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
        required this.mediaList,
        required this.status,
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
    final List<MediaList> mediaList;
    final String? status;

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
            addressDto: json["addressDTO"] == null ? null : AddressDto.fromJson(json["addressDTO"]),
            attributes: json["attributes"] == null ? [] : List<Attribute>.from(json["attributes"]!.map((x) => Attribute.fromJson(x))),
            mediaList: json["mediaList"] == null ? [] : List<MediaList>.from(json["mediaList"]!.map((x) => MediaList.fromJson(x))),
            status: json["status"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "businessName": businessName,
        "approved": approved,
        "enabled": enabled,
        "businessLatitude": businessLatitude,
        "businessLongitude": businessLongitude,
        "categoryName": categoryName,
        "creationDate": creationDate?.toIso8601String(),
        "userDTO": userDto?.toJson(),
        "addressDTO": addressDto?.toJson(),
        "attributes": attributes.map((x) => x?.toJson()).toList(),
        "mediaList": mediaList.map((x) => x?.toJson()).toList(),
        "status": status,
    };

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

    factory AddressDto.fromJson(Map<String, dynamic> json){ 
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

    Map<String, dynamic> toJson() => {
        "id": id,
        "addressLine1": addressLine1,
        "city": city,
        "state": state,
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
        "postalCode": postalCode,
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

    factory Attribute.fromJson(Map<String, dynamic> json){ 
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

class MediaList {
    MediaList({
        required this.id,
        required this.customerId,
        required this.url,
        required this.timeSlot,
        required this.fileName,
        required this.mediaType,
        required this.description,
        required this.extension,
        required this.active,
        required this.createdBy,
        required this.creationTime,
        required this.modificationTime,
        required this.mediaFiles,
        required this.mediaUrls,
    });

    final int? id;
    final dynamic customerId;
    final String? url;
    final String? timeSlot;
    final String? fileName;
    final String? mediaType;
    final String? description;
    final String? extension;
    final bool? active;
    final int? createdBy;
    final DateTime? creationTime;
    final DateTime? modificationTime;
    final dynamic mediaFiles;
    final dynamic mediaUrls;

    factory MediaList.fromJson(Map<String, dynamic> json){ 
        return MediaList(
            id: json["id"],
            customerId: json["customerId"],
            url: json["url"],
            timeSlot: json["timeSlot"],
            fileName: json["fileName"],
            mediaType: json["mediaType"],
            description: json["description"],
            extension: json["extension"],
            active: json["active"],
            createdBy: json["createdBy"],
            creationTime: DateTime.tryParse(json["creationTime"] ?? ""),
            modificationTime: DateTime.tryParse(json["modificationTime"] ?? ""),
            mediaFiles: json["mediaFiles"],
            mediaUrls: json["mediaUrls"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "customerId": customerId,
        "url": url,
        "timeSlot": timeSlot,
        "fileName": fileName,
        "mediaType": mediaType,
        "description": description,
        "extension": extension,
        "active": active,
        "createdBy": createdBy,
        "creationTime": creationTime?.toIso8601String(),
        "modificationTime": modificationTime?.toIso8601String(),
        "mediaFiles": mediaFiles,
        "mediaUrls": mediaUrls,
    };

}

class UserDto {
    UserDto({
        required this.id,
        required this.fullName,
        required this.email,
        required this.primaryContact,
        required this.lastLogOutDate,
        required this.recentActivityDate,
        required this.skillrat,
        required this.yardly,
        required this.eato,
        required this.sancharalakshmi,
        required this.roles,
    });

    final int? id;
    final String? fullName;
    final String? email;
    final String? primaryContact;
    final DateTime? lastLogOutDate;
    final DateTime? recentActivityDate;
    final bool? skillrat;
    final bool? yardly;
    final bool? eato;
    final bool? sancharalakshmi;
    final List<String> roles;

    factory UserDto.fromJson(Map<String, dynamic> json){ 
        return UserDto(
            id: json["id"],
            fullName: json["fullName"],
            email: json["email"],
            primaryContact: json["primaryContact"],
            lastLogOutDate: DateTime.tryParse(json["lastLogOutDate"] ?? ""),
            recentActivityDate: DateTime.tryParse(json["recentActivityDate"] ?? ""),
            skillrat: json["skillrat"],
            yardly: json["yardly"],
            eato: json["eato"],
            sancharalakshmi: json["sancharalakshmi"],
            roles: json["roles"] == null ? [] : List<String>.from(json["roles"]!.map((x) => x)),
        );
    }

 Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "email": email,
        "primaryContact": primaryContact,
        "lastLogOutDate": lastLogOutDate != null
            ? "${lastLogOutDate!.year.toString().padLeft(4, '0')}-${lastLogOutDate!.month.toString().padLeft(2, '0')}-${lastLogOutDate!.day.toString().padLeft(2, '0')}"
            : null,
        "recentActivityDate": recentActivityDate != null
            ? "${recentActivityDate!.year.toString().padLeft(4, '0')}-${recentActivityDate!.month.toString().padLeft(2, '0')}-${recentActivityDate!.day.toString().padLeft(2, '0')}"
            : null,
        "skillrat": skillrat,
        "yardly": yardly,
        "eato": eato,
        "sancharalakshmi": sancharalakshmi,
        "roles": roles.map((x) => x).toList(),
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

    Map<String, dynamic> toJson() => {
        "sort": sort.map((x) => x).toList(),
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "offset": offset,
        "paged": paged,
        "unpaged": unpaged,
    };

}
