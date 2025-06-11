class DefaultAddressModel {
    DefaultAddressModel({
        required this.message,
        required this.status,
        required this.data,
    });

    final String? message;
    final String? status;
    final Data? data;

    factory DefaultAddressModel.fromJson(Map<String, dynamic> json){ 
        return DefaultAddressModel(
            message: json["message"],
            status: json["status"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
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
    final double? latitude;
    final double? longitude;
    final String? postalCode;
    final int? userId;
    final bool? isDefault;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
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

}
